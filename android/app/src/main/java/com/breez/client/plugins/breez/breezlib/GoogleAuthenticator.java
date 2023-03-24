package com.breez.client.plugins.breez.breezlib;

import android.content.Intent;
import android.util.Log;

import com.google.android.gms.auth.UserRecoverableAuthException;
import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.auth.api.signin.GoogleSignInClient;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.common.api.Scope;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;
import com.google.android.gms.tasks.Tasks;
import com.google.api.client.googleapis.extensions.android.gms.auth.GoogleAccountCredential;
import com.google.api.client.googleapis.json.GoogleJsonResponseException;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import com.google.api.services.drive.Drive;
import com.google.api.services.drive.DriveScopes;
import com.google.api.services.drive.model.FileList;

import java.util.Collections;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.PluginRegistry;

public class GoogleAuthenticator implements PluginRegistry.ActivityResultListener {
    private static final String TAG = "BreezGAuthenticator";
    private static final int AUTHORIZE_ACTIVITY_REQUEST_CODE = 84;

    TaskCompletionSource<GoogleSignInAccount> m_signInProgressTask;
    private GoogleSignInClient m_signInClient;
    private final ActivityPluginBinding activityBinding;

    public GoogleAuthenticator(ActivityPluginBinding binding) {
        activityBinding = binding;
        m_signInClient = createSignInClient();
        activityBinding.addActivityResultListener(this);
    }

    public void signOut() throws Exception {
        Log.d(TAG, "Sign out triggered");
        try {
            Tasks.await(m_signInClient.revokeAccess());
        } catch (Exception e) {
            Log.w(TAG, "revokeAccess failed", e);
        }
        Tasks.await(m_signInClient.signOut());
        m_signInClient = createSignInClient();
        Log.i(TAG, "Signed out");
    }

    public GoogleSignInAccount ensureSignedIn(final boolean silent) throws Exception {
        Log.d(TAG, "ensureSignedIn silent = " + silent);
        try {
            Task<GoogleSignInAccount> task = m_signInClient.silentSignIn();
            GoogleSignInAccount result = Tasks.await(task);
            Log.d(TAG, "silentSignIn task successful: " + task.isSuccessful() + ", expired = " + result.isExpired());
            return result;
        } catch (Exception e) {
            Log.w(TAG, "silentSignIn failed", e);
            if (silent) {
                throw new Exception("AuthError");
            }
            Log.i(TAG, "silentSignIn continue to activity");
            return Tasks.await(signIn());
        }
    }

    public String getAccessToken() throws Exception {
        Log.d(TAG, "getAccessToken");
        GoogleSignInAccount googleAccount = ensureSignedIn(true);

        GoogleAccountCredential credential;
        try {
            credential = GoogleAccountCredential.usingOAuth2(
                    activityBinding.getActivity(),
                    Collections.singleton(DriveScopes.DRIVE_APPDATA));
        } catch (Exception e) {
            Log.w(TAG, "getAccessToken failed", e);
            throw e;
        }

        try {
            credential.setSelectedAccount(googleAccount.getAccount());
        } catch (Exception e) {
            Log.w(TAG, "setSelectedAccount failed", e);
            throw e;
        }

        try {
            return credential.getToken();
        } catch (Exception e) {
            Log.w(TAG, "getAccessToken failed", e);
            throw e;
        }
    }

    public boolean validateAccessTokenAllowingPrompt() {
        Log.d(TAG, "getAccessTokenWithPrompt");
        GoogleSignInAccount googleAccount;
        try {
            googleAccount = ensureSignedIn(true);
        } catch (Exception e) {
            Log.w(TAG, "ensureSignedIn failed", e);
            return false;
        }

        GoogleAccountCredential credential;
        try {
            credential = GoogleAccountCredential.usingOAuth2(
                    activityBinding.getActivity(),
                    Collections.singleton(DriveScopes.DRIVE_APPDATA));
        } catch (Exception e) {
            Log.w(TAG, "getAccessTokenWithPrompt failed", e);
            return false;
        }

        try {
            credential.setSelectedAccount(googleAccount.getAccount());
        } catch (Exception e) {
            Log.w(TAG, "setSelectedAccount failed", e);
            throw e;
        }

        try {
            return verifyCredentialHasWriteAccess(credential.getToken(), true);
        } catch (Exception e) {
            Log.w(TAG, "getAccessTokenWithPrompt failed", e);
            if (e instanceof UserRecoverableAuthException) {
                Log.w(TAG, "getAccessTokenWithPrompt failed but it is recoverable, trying to sign in");
                GoogleSignInAccount signInResult;
                try {
                    signInResult = Tasks.await(signIn());
                } catch (Exception ex) {
                    Log.w(TAG, "signIn failed in recoverable", ex);
                    return false;
                }

                try {
                    credential.setSelectedAccount(signInResult.getAccount());
                } catch (Exception ex) {
                    Log.w(TAG, "setSelectedAccount failed in recoverable", ex);
                    return false;
                }

                try {
                    return verifyCredentialHasWriteAccess(credential.getToken(), true);
                } catch (Exception ex) {
                    Log.w(TAG, "getAccessTokenWithPrompt failed in recoverable", ex);
                    return false;
                }
            }
            return false;
        }
    }

    private boolean verifyCredentialHasWriteAccess(String token, boolean allowRecover) {
        Log.d(TAG, "verifyCredentialHasWriteAccess token = " + token);
        if (token == null || token.isEmpty()) {
            return false;
        }

        try {
            Drive driveService = new Drive.Builder(
                    new NetHttpTransport.Builder().build(),
                    new GsonFactory(),
                    request -> {
                    })
                    .setHttpRequestInitializer(req -> req.getHeaders().setAuthorization("Bearer " + token))
                    .setApplicationName("Breez").build();
            FileList result = driveService.files().list().setSpaces("appDataFolder").execute();
            Log.d(TAG, "verifyCredentialHasWriteAccess result = " + result);
        } catch (Exception e) {
            if (e instanceof GoogleJsonResponseException && ((GoogleJsonResponseException) e).getStatusCode() == 401) {
                if (allowRecover) {
                    Log.d(TAG, "verifyCredentialHasWriteAccess failed with 401, trying to sign in to recovery write permission");
                    return recoverUnauthorizedAccess();
                } else {
                    Log.w(TAG, "verifyCredentialHasWriteAccess failed with 401, but not allowed to recover");
                    return false;
                }
            } else {
                Log.w(TAG, "verifyCredentialHasWriteAccess failed", e);
                return false;
            }
        }

        return true;
    }

    private boolean recoverUnauthorizedAccess() {
        Log.d(TAG, "recoverUnauthorizedAccess");
        try {
            signOut();
        } catch (Exception e) {
            Log.w(TAG, "recover signOut failed", e);
            return false;
        }

        GoogleSignInAccount googleAccount;
        try {
            googleAccount = Tasks.await(signIn());
        } catch (Exception e) {
            Log.w(TAG, "recover signIn failed", e);
            return false;
        }

        GoogleAccountCredential credential;
        try {
            credential = GoogleAccountCredential.usingOAuth2(
                    activityBinding.getActivity(),
                    Collections.singleton(DriveScopes.DRIVE_APPDATA));
        } catch (Exception e) {
            Log.w(TAG, "recover failed", e);
            return false;
        }

        String token;
        try {
            credential.setSelectedAccount(googleAccount.getAccount());
            token = credential.getToken();
        } catch (Exception e) {
            // For some reason, on this flow google throws an UserRecoverableAuthException despite of the user
            // be on the auth fow, so we just trigger it again to the user give us the auth on both pages
            if (e instanceof UserRecoverableAuthException) {
                GoogleSignInAccount signInResult;
                try {
                    signInResult = Tasks.await(signIn());
                } catch (Exception ex) {
                    Log.w(TAG, "recover signIn failed", ex);
                    return false;
                }

                try {
                    credential.setSelectedAccount(signInResult.getAccount());
                } catch (Exception ex) {
                    Log.w(TAG, "recover setSelectedAccount failed", ex);
                    return false;
                }

                try {
                    token = credential.getToken();
                } catch (Exception ex) {
                    Log.w(TAG, "recover getToken failed", ex);
                    return false;
                }
            } else {
                Log.w(TAG, "recover failed", e);
                return false;
            }
        }

        return verifyCredentialHasWriteAccess(token, false);
    }

    private GoogleSignInClient createSignInClient() {
        Log.d(TAG, "createSignInClient");
        GoogleSignInOptions signInOptions =
                new GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
                        .requestScopes(new Scope(DriveScopes.DRIVE_APPDATA))
                        .requestEmail()
                        .build();
        return GoogleSignIn.getClient(activityBinding.getActivity(), signInOptions);
    }

    private Task<GoogleSignInAccount> signIn() {
        Log.i(TAG, "Signing in using google activity");
        m_signInProgressTask = new TaskCompletionSource<>();
        activityBinding.getActivity().startActivityForResult(m_signInClient.getSignInIntent(), AUTHORIZE_ACTIVITY_REQUEST_CODE);
        return m_signInProgressTask.getTask();
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent intent) {
        if (requestCode == AUTHORIZE_ACTIVITY_REQUEST_CODE && m_signInProgressTask != null) {
            Log.i(TAG, "onActivityResult requestCode = " + requestCode + " resultCode = " + resultCode + " intent came back with result");
            GoogleSignIn.getSignedInAccountFromIntent(intent).addOnCompleteListener(task -> {
                try {
                    task.getResult(ApiException.class);
                    GoogleSignInAccount res = task.getResult();

                    Log.i(TAG, "Sign in intent success, token = " + res.getAccount());
                    m_signInProgressTask.setResult(task.getResult());
                } catch (ApiException e) {
                    m_signInProgressTask.setException(new Exception("AuthError"));
                    Log.w(TAG, "Sign in Failed… " + e.getMessage(), e);
                }
            });
            return true;
        }
        return false;
    }
}
