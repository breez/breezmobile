package com.breez.client.plugins.breez.backup;

import android.app.Activity;
import android.content.Intent;
import android.support.annotation.NonNull;
import android.util.Log;

import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.tasks.Continuation;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.drive.*;
import com.google.android.gms.signin.*;
import com.google.android.gms.auth.api.signin.*;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;

import io.flutter.plugin.common.PluginRegistry;

import static android.app.Activity.RESULT_OK;

public class GoogleAuthenticator implements PluginRegistry.ActivityResultListener{
    private static final String TAG = "BreezGAuthenticator";
    private static final int AUTHORIZE_ACTIVITY_REQUEST_CODE = 84;

    private Activity m_breezActivity;
    TaskCompletionSource<GoogleSignInAccount> m_signInProgressTask;
    private GoogleSignInClient m_signInClient;

    public GoogleAuthenticator(PluginRegistry.Registrar registrar) {
        m_breezActivity = registrar.activity();
        m_signInClient = createSignInClient();
        registrar.addActivityResultListener(this);        
    }

    public Task<Void> signOut(){
        GoogleSignInClient old = m_signInClient;
        m_signInClient = createSignInClient();
        return old.signOut();
    }

    public Task<GoogleSignInAccount> ensureSignedIn(final boolean silent) {
        Task<GoogleSignInAccount> task = m_signInClient.silentSignIn();
        if (task.isSuccessful()) {
            Log.i(TAG, "silentSignIn Task is already successfull");
            return task;
        }


        return task.continueWithTask(new Continuation<GoogleSignInAccount, Task<GoogleSignInAccount>>() {
            @Override
            public Task<GoogleSignInAccount> then(@NonNull Task<GoogleSignInAccount> task) throws Exception {
                if (task.isSuccessful() || silent) {
                    Log.i(TAG, "silentSignIn Task succeeded");
                    return task;
                }

                return signIn();
            }
        });
    }

    private GoogleSignInClient createSignInClient(){
        GoogleSignInOptions signInOptions =
                new GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
                        .requestScopes(Drive.SCOPE_APPFOLDER)
                        .build();
        return GoogleSignIn.getClient(m_breezActivity, signInOptions);
    }

    private Task<GoogleSignInAccount> signIn(){
        Log.i(TAG, "Signing in using google activity");
        m_signInProgressTask = new TaskCompletionSource<GoogleSignInAccount>();
        m_breezActivity.startActivityForResult(m_signInClient.getSignInIntent(), AUTHORIZE_ACTIVITY_REQUEST_CODE);
        return m_signInProgressTask.getTask();
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent intent) {
        if (requestCode == AUTHORIZE_ACTIVITY_REQUEST_CODE && m_signInProgressTask != null) {
            Log.i(TAG, "onActivityResult requestCode = " + requestCode + " resultCode = " + resultCode + " intent came back with result");
            GoogleSignIn.getSignedInAccountFromIntent(intent).addOnCompleteListener(new OnCompleteListener<GoogleSignInAccount>() {
                @Override
                public void onComplete(@NonNull Task<GoogleSignInAccount> task) {
                    if (!task.isSuccessful()) {
                        m_signInProgressTask.setException(task.getException());
                        return;
                    }

                    m_signInProgressTask.setResult(task.getResult());
                }
            });
            return true;
        }
        return false;
    }
}
