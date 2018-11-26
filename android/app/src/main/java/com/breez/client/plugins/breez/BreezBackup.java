package com.breez.client.plugins.breez;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.auth.api.signin.GoogleSignInClient;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.drive.Drive;
import com.google.android.gms.drive.DriveClient;
import com.google.android.gms.drive.DriveContents;
import com.google.android.gms.drive.DriveFile;
import com.google.android.gms.drive.DriveFolder;
import com.google.android.gms.drive.DriveResourceClient;
import com.google.android.gms.drive.MetadataBuffer;
import com.google.android.gms.drive.MetadataChangeSet;
import com.google.android.gms.drive.query.Filters;
import com.google.android.gms.drive.query.Query;
import com.google.android.gms.drive.query.SearchableField;
import com.google.android.gms.tasks.Task;

import java.io.FileInputStream;
import java.io.OutputStream;
import java.util.List;
import java.io.File;
import java.util.Date;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

import static android.app.Activity.RESULT_OK;

public class BreezBackup implements MethodChannel.MethodCallHandler,
        PluginRegistry.ActivityResultListener {
    private static final String TAG = "BreezBackup";
    public static final String BREEZ_BACKUP_CHANNEL_NAME = "com.breez.client/backup";
    public static final String BREEZ_BACKUP_STREAM_NAME = "com.breez.client/backup_stream";

    private final int AUTHORIZE_ACTIVITY_REQUEST_CODE = 84;
    private final Activity m_activity;
    private MethodChannel m_methodChannel;
    private MethodChannel.Result m_result;

    private GoogleSignInClient m_googleSignInClient;
    private DriveClient m_driveClient;
    private DriveResourceClient m_driveResourceClient;

    public BreezBackup(PluginRegistry.Registrar registrar, Activity activity) {
        this.m_activity = activity;
        m_methodChannel = new MethodChannel(registrar.messenger(), BREEZ_BACKUP_CHANNEL_NAME);
        m_methodChannel.setMethodCallHandler(this);

        registrar.addActivityResultListener(this);

        m_googleSignInClient = buildGoogleSignInClient();
    }

    private GoogleSignInClient buildGoogleSignInClient() {
        GoogleSignInOptions signInOptions =
                new GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
                        .requestScopes(Drive.SCOPE_APPFOLDER)
                        .build();
        return GoogleSignIn.getClient(m_activity, signInOptions);
    }

    private void getDriveClients(Task<GoogleSignInAccount> task) {
        Log.i(TAG, "Update view with sign in account task");
        task.addOnSuccessListener(
                googleSignInAccount -> {
                    Log.i(TAG, "Sign in success");
                    m_driveClient = Drive.getDriveClient(m_activity, googleSignInAccount);
                    m_driveResourceClient =
                            Drive.getDriveResourceClient(m_activity, googleSignInAccount);
                    m_result.success(true);

                })
                .addOnFailureListener(
                        e -> {
                            Log.w(TAG, "Sign in failed", e);
                            m_result.error("Sign in failed", "Sign in failed", "Sign in failed");
                        });
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == AUTHORIZE_ACTIVITY_REQUEST_CODE) {
            if (resultCode == RESULT_OK) {
                getDriveClients(m_googleSignInClient.silentSignIn());
            }
            return true;
        }
        return false;
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("authorize")) {
            Intent signInIntent = m_googleSignInClient.getSignInIntent();
            m_result = result;
            m_activity.startActivityForResult(signInIntent, AUTHORIZE_ACTIVITY_REQUEST_CODE);
        }
        if (call.method.equals("backup")) {
            List<String> paths = call.argument("paths");
            String nodeId = call.argument("nodeId").toString();
            createNodeIdFolder(paths, nodeId);
        }
        if (call.method.equals("listNodeIds")) {
            listNodeIds();
        }
        if (call.method.equals("restore")) {
            String nodeId = call.argument("nodeId").toString();
            listNodeIds();
        }
    }

    private void updateBackupFiles(List<String> paths, DriveFolder nodeIdFolder) {
        for (String path: paths) {
            m_driveResourceClient.createContents()
                    .continueWithTask(task -> {
                        DriveContents contents = task.getResult();
                        OutputStream outputStream = contents.getOutputStream();

                        File file = new File(path);
                        FileInputStream inputStream = new FileInputStream(file);

                        byte[] buffer = new byte[inputStream.available()];
                        inputStream.read(buffer, 0, inputStream.available());
                        outputStream.write(buffer);

                        MetadataChangeSet changeSet = new MetadataChangeSet.Builder()
                                .setTitle(file.getName())
                                .setMimeType("text/plain")
                                .setStarred(true)
                                .build();

                        return m_driveResourceClient.createFile(nodeIdFolder, changeSet, contents);
                    })
                    .addOnSuccessListener(m_activity,
                            driveFile -> {
                                Log.i(TAG, "File created!");
                            })
                    .addOnFailureListener(m_activity, e -> {
                        Log.e(TAG, "Unable to create file", e);
                        m_result.error("CREATE_FILE_FAILURE", "Unable to create file", null);
                        return;
                    });
        }
    }

    private void createNodeIdFolder(List<String> paths, String nodeId) {
        m_driveResourceClient
                .getAppFolder()
                .continueWithTask(task -> {
                    DriveFolder appFolder = task.getResult();
                    MetadataChangeSet changeSet = new MetadataChangeSet.Builder()
                            .setTitle(nodeId)
                            .setMimeType(DriveFolder.MIME_TYPE)
                            .setStarred(true)
                            .setLastViewedByMeDate(new Date())
                            .build();
                    return m_driveResourceClient.createFolder(appFolder, changeSet);
                })
                .addOnSuccessListener(m_activity,
                        driveFolder -> {
                            updateBackupFiles(paths, driveFolder);
                        })
                .addOnFailureListener(m_activity, e -> {
                    Log.e(TAG, "Unable to create folder", e);
                    m_result.error("CREATE_FOLDER_FAILURE", "Unable to create folder", null);
                });
    }

    private void listNodeIds() {
        m_driveResourceClient
                .getAppFolder()
                .continueWithTask(task -> {
                    DriveFolder appFolder = task.getResult();
                    Query query = new Query.Builder()
                            .addFilter(Filters.eq(SearchableField.MIME_TYPE, DriveFolder.MIME_TYPE))
                            .build();

                    Task<MetadataBuffer> queryTask = m_driveResourceClient.queryChildren(appFolder, query);
                    return  queryTask
                            .addOnSuccessListener(m_activity,
                                    metadataBuffer -> {
                                        Log.w(TAG, metadataBuffer.toString());
                                        // send the list
                                    })
                            .addOnFailureListener(m_activity, e -> {
                                Log.e(TAG, "Error retrieving files", e);
                            });
                });
    }

    private void getNodeIdFolder(String nodeId) {
        m_driveResourceClient
                .getAppFolder()
                .continueWithTask(task -> {
                    DriveFolder appFolder = task.getResult();
                    Query query = new Query.Builder()
                            .addFilter(Filters.eq(SearchableField.MIME_TYPE, DriveFolder.MIME_TYPE))
                            .addFilter(Filters.eq(SearchableField.TITLE, nodeId))
                            .build();

                    Task<MetadataBuffer> queryTask = m_driveResourceClient.queryChildren(appFolder, query);
                    return  queryTask
                            .addOnSuccessListener(m_activity,
                                    metadataBuffer -> {
                                        Log.w(TAG, metadataBuffer.toString());
                                        // got the backup folder
                                    })
                            .addOnFailureListener(m_activity, e -> {
                                Log.e(TAG, "Error retrieving files", e);
                            });
                });
    }

    private void getBackupFiles(DriveFolder nodeIdFolder) {
        Query query = new Query.Builder()
                .build();

        Task<MetadataBuffer> queryTask = m_driveResourceClient.queryChildren(nodeIdFolder, query);

        queryTask
                .addOnSuccessListener(m_activity,
                        metadataBuffer -> {

                        })
                .addOnFailureListener(m_activity, e -> {

                });
    }
}

