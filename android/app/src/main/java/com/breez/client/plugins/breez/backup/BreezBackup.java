package com.breez.client.plugins.breez.backup;

import android.app.Activity;
import android.content.Intent;
import android.support.annotation.NonNull;
import android.util.Log;
import com.google.android.gms.auth.api.signin.*;
import com.google.android.gms.drive.*;
import com.google.android.gms.drive.metadata.CustomPropertyKey;
import com.google.android.gms.drive.query.*;
import com.google.android.gms.tasks.*;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.io.File;
import java.util.Date;
import java.util.concurrent.atomic.AtomicInteger;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

import static android.app.Activity.RESULT_OK;

public class BreezBackup implements MethodChannel.MethodCallHandler {
    private static final String TAG = "BreezBackup";
    public static final String BREEZ_BACKUP_CHANNEL_NAME = "com.breez.client/backup";
    private final Activity m_activity;
    private MethodChannel m_methodChannel;
    private GoogleAuthenticator m_authenticator;
    private DriveResourceClient m_driveResourceClient;

    public BreezBackup(PluginRegistry.Registrar registrar, Activity activity) {
        this.m_activity = activity;
        m_methodChannel = new MethodChannel(registrar.messenger(), BREEZ_BACKUP_CHANNEL_NAME);
        m_methodChannel.setMethodCallHandler(this);
        m_authenticator = new GoogleAuthenticator(registrar);
    }

    @Override
    public void onMethodCall(final MethodCall call, final MethodChannel.Result result) {
        Log.i(TAG, "onMethodCall: " + call.method);

        if (call.method.equals("signOut")) {
            signOut(result);
            return;
        }

        Boolean silent = call.argument("silent");
        m_authenticator.ensureSignedIn(silent != null && silent.booleanValue()).addOnCompleteListener(new OnCompleteListener<GoogleSignInAccount>() {
            @Override
            public void onComplete(@NonNull Task<GoogleSignInAccount> task) {
                if (!task.isSuccessful()) {
                    Log.e(TAG, "ensureSignedIn failed", task.getException());
                    result.error("Error in BreezBackup.onMethodCall " + call.method, task.getException().getMessage(), task.getException().toString());
                    return;
                }
                GoogleSignInAccount loggedInAccount = task.getResult();
                if (m_driveResourceClient == null) {
                    Drive.getDriveClient(m_activity, loggedInAccount).requestSync().addOnCompleteListener(new OnCompleteListener<Void>() {
                        @Override
                        public void onComplete(@NonNull Task<Void> syncTask) {
                            m_driveResourceClient = Drive.getDriveResourceClient(m_activity, loggedInAccount);
                            handleMethodCall(call, result);
                        }
                    });
                    return;
                }
                handleMethodCall(call, result);
            }
        });
    }

    private void handleMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("backup")) {
            List<String> paths = call.argument("paths");
            String nodeId = call.argument("nodeId").toString();
            backup(paths, nodeId, result);
        }
        if (call.method.equals("availableBackups")) {
            listAvailableBackups(result);
        }
        if (call.method.equals("restore")) {
            String nodeId = call.argument("nodeId").toString();
            restore(nodeId, result);
        }
    }

    private void signOut(MethodChannel.Result result){
        m_authenticator.signOut().addOnCompleteListener(new OnCompleteListener<Void>() {
            @Override
            public void onComplete(@NonNull Task<Void> task) {
                if (task.isSuccessful()) {
                    m_driveResourceClient = null;
                    result.success(true);
                } else {
                    result.error("signOut failed", task.getException().getMessage(), null);
                }
            }
        });
    }

    private void listAvailableBackups(MethodChannel.Result result){
        fetchAppFolders()
                .addOnSuccessListener(result::success)
                .addOnFailureListener(e -> result.error("Failed to backup", e.getMessage(), e.toString()));
    }

    private void backup(List<String> paths, String nodeId, MethodChannel.Result result) {
        getOrCreateNodeIdFolder(nodeId)
                .continueWith(folderTask -> uploadBackupFiles(paths, folderTask.getResult())
                .addOnSuccessListener(res -> result.success(true))
                .addOnFailureListener(e -> result.error("Failed to backup", e.getMessage(), e.toString())));
    }

    private void restore(String nodeId, MethodChannel.Result result){
        new GoogleDriveTasks(m_driveResourceClient).getFolderByTitle(nodeId)
                .continueWithTask(nodeFolder -> {
                    return downloadBackupFiles(nodeFolder.getResult());
                })
                .addOnSuccessListener(result::success)
                .addOnFailureListener(e -> {
                    result.error("Failed to restore", e.getMessage(), e.toString());
                });
    }

    private Task<DriveFolder> getOrCreateNodeIdFolder(String nodeId){
        return new GoogleDriveTasks(m_driveResourceClient).getFolderByTitle(nodeId)
                .continueWithTask(nodeIdTask -> {
                    if (nodeIdTask.isSuccessful() && nodeIdTask.getResult() != null) {
                        return nodeIdTask;
                    }
                    return createNodeFolder(nodeId);
                });
    }

    private Task<DriveFolder> createNodeFolder(String nodeId){
        return m_driveResourceClient
                .getAppFolder()
                .continueWithTask(task -> {
                    DriveFolder appFolder = task.getResult();
                    MetadataChangeSet changeSet = new MetadataChangeSet.Builder()
                            .setTitle(nodeId)
                            .setMimeType(DriveFolder.MIME_TYPE)
                            .setStarred(true)
                            .build();
                    return m_driveResourceClient.createFolder(appFolder, changeSet);
                });
    }


    private Task<HashMap<String, String>> fetchAppFolders(){
        return m_driveResourceClient
                .getAppFolder()
                .continueWithTask(task -> {
                    DriveFolder appFolder = task.getResult();

                    return new GoogleDriveTasks(m_driveResourceClient).getNestedFolders(appFolder);
                });
    }

    /**upload backup files**/

    private Task<Void> uploadBackupFiles(List<String> paths, DriveFolder nodeIdFolder) {
        Log.i(TAG, "updateBackupFiles in nodeID = " + nodeIdFolder.toString());
        GoogleDriveTasks tasksExecutor = new GoogleDriveTasks(m_driveResourceClient);
        return m_driveResourceClient.createFolder(nodeIdFolder, new MetadataChangeSet.Builder().setTitle("backup").build())
                .continueWithTask(backupFolderTask -> {
                    DriveFolder backupFolder = backupFolderTask.getResult();
                    List<Task<DriveFile>> uploadTasks = new ArrayList<Task<DriveFile>>();
                    for (String path: paths) {
                        uploadTasks.add(tasksExecutor.uploadFile(backupFolder, path));
                    }

                    return Tasks.whenAllComplete(uploadTasks)
                            .continueWith(listTask -> {
                                if (listTask.getResult().size() == paths.size()) {
                                    return null;
                                }

                                throw new Exception("Could not upload all backup files");
                            })
                            .continueWith(res -> {
                                MetadataChangeSet changeSet = new MetadataChangeSet.Builder()
                                        .setCustomProperty(
                                                new CustomPropertyKey("backupFolderResourceID", CustomPropertyKey.PRIVATE), backupFolder.getDriveId().getResourceId())
                                        .build();
                                return m_driveResourceClient.updateMetadata(nodeIdFolder, changeSet);
                            })
                            .continueWith(metadataTask -> {
                                return null;
                            });
                });
    }


    /**download backup files**/

    private Task<List<String>> downloadBackupFiles(DriveFolder nodeIdFolder) {
        GoogleDriveTasks tasksExecutor = new GoogleDriveTasks(m_driveResourceClient);
        return m_driveResourceClient.getMetadata(nodeIdFolder)
                .continueWithTask(metadataTask -> {
                    Metadata metadata = metadataTask.getResult();
                    String backupFolderID = metadata.getCustomProperties().get(new CustomPropertyKey("backupFolderResourceID", CustomPropertyKey.PRIVATE));
                    return tasksExecutor.findChildByResourceID(nodeIdFolder, backupFolderID);
                })
                .continueWithTask(innerFolder -> {
                    return m_driveResourceClient.queryChildren(innerFolder.getResult(), new Query.Builder().build())
                            .continueWithTask(metadataBufferTask -> {
                                MetadataBuffer metadataBuffer = metadataBufferTask.getResult();
                                List<Task<String>> downloadedFiles = new ArrayList<Task<String>>();

                                for (Metadata m : metadataBuffer) {
                                    downloadedFiles.add(tasksExecutor.downloadDriveFile(m, m_activity.getCacheDir().getPath()));
                                }

                                return Tasks.whenAllComplete(downloadedFiles)
                                        .continueWith(successfullTasks -> {
                                            if (successfullTasks.getResult().size() != downloadedFiles.size()) {
                                                throw new Exception("Failed to download all restore files");
                                            }
                                            List<String> backupPathsList = new ArrayList<>();
                                            for (Task<String> downloadedFile : downloadedFiles) {
                                                backupPathsList.add(downloadedFile.getResult());
                                            }
                                            return backupPathsList;
                                        });

                            });
                });

    }
}

