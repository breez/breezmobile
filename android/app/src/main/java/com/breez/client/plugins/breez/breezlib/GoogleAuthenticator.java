package com.breez.client.plugins.breez.breezlib;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import androidx.annotation.Nullable;

import com.breez.client.R;
import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.auth.api.signin.GoogleSignInClient;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.auth.api.signin.GoogleSignInStatusCodes;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.common.api.CommonStatusCodes;
import com.google.android.gms.common.api.Scope;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;
import com.google.android.gms.tasks.Tasks;
import com.google.api.client.googleapis.extensions.android.gms.auth.GoogleAccountCredential;
import com.google.api.services.drive.DriveScopes;

import java.util.Collections;
import java.util.concurrent.ExecutionException;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.PluginRegistry;

public class GoogleAuthenticator implements PluginRegistry.ActivityResultListener {
    private static final String TAG = "BreezGAuthenticator";
    private static final int AUTHORIZE_ACTIVITY_REQUEST_CODE = 84;
    private static final int RC_REQUEST_PERMISSION_APP_DATA = 83;
    private static final int SIGN_IN_CANCELLED = 12501;
    private static final Scope appDataScope = new Scope(DriveScopes.DRIVE_APPDATA);
    private final ActivityPluginBinding activityBinding;
    TaskCompletionSource<GoogleSignInAccount> m_signInProgressTask;
    TaskCompletionSource<Boolean> m_scopeRequestTask;
    private GoogleSignInClient m_signInClient;

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
            GoogleSignInAccount signedInAccount = GoogleSignIn.getLastSignedInAccount(activityBinding.getActivity());
            if (!isAuthenticated(signedInAccount)) {
                Task<GoogleSignInAccount> task = m_signInClient.silentSignIn();
                if (task.isSuccessful()) {
                    Log.d(TAG, "Google silentSignIn isSuccessful.");
                    // There's immediate result available.
                    signedInAccount = task.getResult(ApiException.class);
                    Log.d(TAG, "signedInAccount: {\n    expired = " + signedInAccount.isExpired() + ",\n    token = " + signedInAccount.getIdToken() + ",\n    grantedScopes = " + signedInAccount.getGrantedScopes() + "\n}");
                    Log.d(TAG, "Google silentSignIn succeed.");
                    return signedInAccount;
                } else {
                    // There's no immediate result ready
                    return Tasks.await(signIn());
                }
            }
            return signedInAccount;
        } catch (Exception e) {
            Log.w(TAG, "silentSignIn failed", e);
            if (e.getMessage().contains("SignInCancelled")) {
                throw new Exception("SignInCancelled");
            }
            if (silent) {
                throw new Exception("AuthError");
            }
            if (googleSignNotAvailable(e)) {
                throw new Exception("GoogleSignNotAvailable");
            }
            Log.i(TAG, "silentSignIn continue to activity");
            return Tasks.await(signIn());
        }
    }

    public String getAccessToken() throws Exception {
        Log.d(TAG, "getAccessToken");
        m_signInClient = createSignInClient();
        GoogleSignInAccount googleAccount = ensureSignedIn(true);
        try {
            GoogleAccountCredential credential = credential();
            credential.setSelectedAccount(googleAccount.getAccount());
            return credential.getToken();
        } catch (Exception e) {
            // TODO Handle NEED_REMOTE_CONSENT error
           /* if (e.getMessage().contains("NEED_REMOTE_CONSENT")) {
                Tasks.await(requestAppDataScope());
                return getAccessToken();
            }*/
            Log.w(TAG, "getAccessToken failed", e);
            throw e;
        }
    }

    private GoogleSignInClient createSignInClient() {
        Log.d(TAG, "createSignInClient");
        final Activity context = activityBinding.getActivity();
        GoogleSignInOptions signInOptions =
                new GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
                        .requestScopes(appDataScope)
                        .requestEmail()
                        .requestIdToken(context.getString(R.string.default_web_client_id))
                        .build();
        return GoogleSignIn.getClient(context, signInOptions);
    }

    private Task<GoogleSignInAccount> signIn() {
        Log.i(TAG, "Signing in using google activity");
        m_signInProgressTask = new TaskCompletionSource<>();
        activityBinding.getActivity().startActivityForResult(m_signInClient.getSignInIntent(), AUTHORIZE_ACTIVITY_REQUEST_CODE);
        return m_signInProgressTask.getTask();
    }

    private GoogleAccountCredential credential() {
        return GoogleAccountCredential.usingOAuth2(
                activityBinding.getActivity(),
                Collections.singleton(DriveScopes.DRIVE_APPDATA));
    }

    private boolean googleSignNotAvailable(Exception e) {
        if (!(e instanceof ExecutionException)) {
            Log.v(TAG, "checkSignIsPossible not ExecutionException");
            return false;
        }
        Throwable cause = e.getCause();
        if (!(cause instanceof ApiException)) {
            Log.v(TAG, "checkSignIsPossible not ApiException");
            return false;
        }
        ApiException apiException = (ApiException) cause;
        if (apiException.getStatusCode() != CommonStatusCodes.API_NOT_CONNECTED) {
            Log.v(TAG, "checkSignIsPossible not API_NOT_CONNECTED");
            return false;
        }
        ConnectionResult result = apiException.getStatus().getConnectionResult();
        if (result == null) {
            Log.v(TAG, "checkSignIsPossible result is null");
            return false;
        }
        if (result.getErrorCode() == ConnectionResult.SERVICE_INVALID) {
            Log.v(TAG, "checkSignIsPossible SERVICE_INVALID");
            return true;
        }
        Log.v(TAG, "checkSignIsPossible error code not handled " + result.getErrorCode());
        return false;
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        Log.i(TAG, "onActivityResult requestCode = " + requestCode + " resultCode = " + resultCode + " intent came back with result");
        switch (requestCode) {
            case RC_REQUEST_PERMISSION_APP_DATA:
                handleScopeRequestResult(resultCode);
                return true;
            case AUTHORIZE_ACTIVITY_REQUEST_CODE:
                if (m_signInProgressTask != null) {
                    // The Task returned from this call is always completed, no need to attach
                    // a listener.
                    Task<GoogleSignInAccount> task = GoogleSignIn.getSignedInAccountFromIntent(data);
                    handleSignInResult(task);
                    return true;
                }
        }
        return false;
    }

    private void handleSignInResult(Task<GoogleSignInAccount> completedTask) {
        try {
            GoogleSignInAccount account = completedTask.getResult(ApiException.class);

            // Signed in successfully
            Log.i(TAG, "signInResult:success token = " + account.getIdToken());
            m_signInProgressTask.setResult(account);
        } catch (ApiException e) {
            Log.w(TAG, "signInResult:failed\n" + GoogleSignInStatusCodes.getStatusCodeString(e.getStatusCode()));
            Log.w(TAG, "code=" + e.getStatusCode() + "\nmessage=" + e.getMessage(), e);
            if (e.getStatusCode() == SIGN_IN_CANCELLED) { /*12501*/
                m_signInProgressTask.setException(new Exception("SignInCancelled"));
            } else {
                m_signInProgressTask.setException(new Exception("AuthError"));
            }
        }
    }

    public boolean isAuthenticated(@Nullable GoogleSignInAccount account) {
        if (account != null) {
            if (account.getIdToken() == null) {
                Log.d(TAG, "Google account found, but there is no token to check or refresh.");

                return false;
            }
        }

        return account != null;
    }

    public boolean hasWritePermissions(@Nullable GoogleSignInAccount account) throws Exception {
        boolean accountHasWritePermissions = account.getGrantedScopes().contains(appDataScope);
        if (!accountHasWritePermissions) {
            Log.i(TAG, "Account has not given permission to Breez to view and manage its " + "own configuration data in your Google Drive.");
            return Tasks.await(requestAppDataScope());
        }

        return true;
    }

    private Task<Boolean> requestAppDataScope() {
        Log.i(TAG, "Requesting app data scope");
        m_scopeRequestTask = new TaskCompletionSource<>();
        GoogleSignIn.requestPermissions(
                activityBinding.getActivity(),
                RC_REQUEST_PERMISSION_APP_DATA,
                GoogleSignIn.getLastSignedInAccount(activityBinding.getActivity()),
                appDataScope);
        return m_scopeRequestTask.getTask();
    }

    private void handleScopeRequestResult(int resultCode) {
        if (resultCode == Activity.RESULT_OK) {
            Log.i(TAG, "requestPermissions:success");
            m_scopeRequestTask.setResult(true);
        } else {
            m_scopeRequestTask.setException(new Exception("ACCESS_TOKEN_SCOPE_INSUFFICIENT"));
        }
    }
}
