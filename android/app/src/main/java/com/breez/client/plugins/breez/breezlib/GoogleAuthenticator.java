package com.breez.client.plugins.breez.breezlib;

import android.content.Intent;
import androidx.annotation.NonNull;
import android.util.Log;

import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.auth.api.signin.GoogleSignInClient;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.common.api.Scope;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;
import com.google.android.gms.tasks.Tasks;
import com.google.api.client.googleapis.extensions.android.gms.auth.GoogleAccountCredential;
import com.google.api.services.drive.DriveScopes;

import java.util.Collections;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.PluginRegistry;

public class GoogleAuthenticator implements PluginRegistry.ActivityResultListener{
    private static final String TAG = "BreezGAuthenticator";
    private static final int AUTHORIZE_ACTIVITY_REQUEST_CODE = 84;

    TaskCompletionSource<GoogleSignInAccount> m_signInProgressTask;
    private GoogleSignInClient m_signInClient;
    private ActivityPluginBinding activityBinding;

    public GoogleAuthenticator(ActivityPluginBinding binding) {
        activityBinding = binding;
        m_signInClient = createSignInClient();
        activityBinding.addActivityResultListener(this);
    }

    public void signOut() throws Exception{
        try {
            Tasks.await(m_signInClient.revokeAccess());
        } catch (Exception e){}
        Tasks.await(m_signInClient.signOut());
        m_signInClient = createSignInClient();
        Log.i(TAG, "Signed out");
    }

    public GoogleSignInAccount ensureSignedIn(final boolean silent) throws Exception {
        try {
            return Tasks.await(m_signInClient.silentSignIn());
        }
        catch (Exception e) {
            Log.i(TAG, "silentSignIn failed");
            if (silent) {
                throw new Exception("AuthError");
            }
            Log.i(TAG, "silentSignIn continue to activity");
            return Tasks.await(signIn());
        }
    }

    public String getAccessToken() throws Exception{
        GoogleSignInAccount googleAccount = ensureSignedIn(true);
        GoogleAccountCredential credential =
                GoogleAccountCredential.usingOAuth2(
                        activityBinding.getActivity(), Collections.singleton(DriveScopes.DRIVE_APPDATA));

        credential.setSelectedAccount(googleAccount.getAccount());
        return credential.getToken();
    }

    private GoogleSignInClient createSignInClient(){
        GoogleSignInOptions signInOptions =
                new GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
                        .requestScopes( new Scope(DriveScopes.DRIVE_APPDATA))
                        .requestEmail()
                        .build();
        return GoogleSignIn.getClient(activityBinding.getActivity(), signInOptions);
    }

    private Task<GoogleSignInAccount> signIn(){
        Log.i(TAG, "Signing in using google activity");
        m_signInProgressTask = new TaskCompletionSource<GoogleSignInAccount>();
        activityBinding.getActivity().startActivityForResult(m_signInClient.getSignInIntent(), AUTHORIZE_ACTIVITY_REQUEST_CODE);
        return m_signInProgressTask.getTask();
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent intent) {
        if (requestCode == AUTHORIZE_ACTIVITY_REQUEST_CODE && m_signInProgressTask != null) {
            Log.i(TAG, "onActivityResult requestCode = " + requestCode + " resultCode = " + resultCode + " intent came back with result");
            GoogleSignIn.getSignedInAccountFromIntent(intent).addOnCompleteListener(new OnCompleteListener<GoogleSignInAccount>() {
                @Override
                public void onComplete(@NonNull Task<GoogleSignInAccount> task) {
                    try {
                        task.getResult(ApiException.class);
                        GoogleSignInAccount res = task.getResult();

                        Log.i(TAG, "Sign in intent success, ,token = " + res.getAccount());
                        m_signInProgressTask.setResult(task.getResult());
                    } catch (ApiException e) {
                        m_signInProgressTask.setException(new Exception("AuthError"));
                        Log.i(TAG, "Sign in Failed...");
                        return;
                    }
                }
            });
            return true;
        }
        return false;
    }
}
