package com.breez.client.plugins.breez.backup;

import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.support.annotation.NonNull;
import android.util.Log;
import com.google.android.gms.auth.api.signin.*;
import com.google.android.gms.drive.*;
import com.google.android.gms.drive.events.ChangeEvent;
import com.google.android.gms.drive.events.ListenerToken;
import com.google.android.gms.drive.events.OnChangeListener;
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
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.function.Function;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

import static android.app.Activity.RESULT_OK;

public class BreezBackup implements MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    public static final String BREEZ_BACKUP_CHANNEL_NAME = "com.breez.client/backup";
    public static final String SIGN_IN_FAILED_CODE = "SIGN_IN_FAILED";
    public static final String BACKUP_CONFLICT_ERROR_CODE = "BACKUP_CONFLICT_ERROR";
    public static final String BREEZ_BACKUP_CHANGES_STREAM_NAME = "com.breez.client/breez_backup_changes_stream";

    private static final CustomPropertyKey BREEZ_ID_CUSTOM_PROPERTY = new CustomPropertyKey("backupBeezID", CustomPropertyKey.PRIVATE);
    private static final CustomPropertyKey FOLDER_ID_CUSTOM_PROPERTY = new CustomPropertyKey("backupFolderID", CustomPropertyKey.PRIVATE);

    private static final String TAG = "BreezBackup";
    private final Activity m_activity;
    private GoogleAuthenticator m_authenticator;
    private volatile DriveResourceClient m_driveResourceClient;
    private volatile BackupChangesListener m_eventsListener;
    private ListenerToken m_changesToken;

    public BreezBackup(PluginRegistry.Registrar registrar, Activity activity) {
        this.m_activity = activity;
        new MethodChannel(registrar.messenger(), BREEZ_BACKUP_CHANNEL_NAME).setMethodCallHandler(this);
        new EventChannel(registrar.messenger(), BREEZ_BACKUP_CHANGES_STREAM_NAME).setStreamHandler(this);
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
        new BackupTask(t -> {
            try
            {
                initDriveResourceClient(silent != null && silent.booleanValue());
                handleMethodCall(call, result);
            }
            catch(ExecutionException e) {
                Log.e(TAG, "sign in failed " + e.getMessage(), e);
                if (e.getCause() instanceof SignInFailedException) {
                    result.error(SIGN_IN_FAILED_CODE, e.getMessage(), e.toString());
                } else {
                    result.error("Unhandled Error", e.getMessage(), e.toString());
                }
            }
            catch(Exception e) {
                Log.e(TAG, "Unhandled Error " + e.getMessage(), e);
                result.error("Unhandled Error", e.getMessage(), e.toString());
            }
            return null;
        }).execute();
    }

    private synchronized DriveResourceClient initDriveResourceClient(boolean silent) throws Exception{
        if (m_driveResourceClient == null) {
            GoogleSignInAccount loggedInAccount = Tasks.await(m_authenticator.ensureSignedIn(silent));
            DriveClient driveClient =  Drive.getDriveClient(m_activity, loggedInAccount);
            Tasks.await(driveClient.requestSync());
            m_driveResourceClient = Drive.getDriveResourceClient(m_activity, loggedInAccount);
            if (m_eventsListener != null) {
                registerChangesListener(m_driveResourceClient);
            }
        }
        return m_driveResourceClient;
    }

    private synchronized void destroyDriveResourceClient(){
        if (m_driveResourceClient != null) {
            clearChangesListener(m_driveResourceClient);
            m_driveResourceClient = null;
        }
    }

    private void signOut(MethodChannel.Result result){
        m_authenticator.signOut().addOnCompleteListener(new OnCompleteListener<Void>() {
            @Override
            public void onComplete(@NonNull Task<Void> task) {
                if (task.isSuccessful()) {
                    destroyDriveResourceClient();
                    result.success(true);
                } else {
                    result.error("signOut failed", task.getException().getMessage(), null);
                }
            }
        });
    }

    private void handleMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("backup")) {
            List<String> paths = call.argument("paths");
            String nodeId = call.argument("nodeId").toString();
            String breezBackupID = call.argument("breezBackupID").toString();
            backup(paths, breezBackupID, nodeId, result);
        }
        if (call.method.equals("getAvailableBackups")) {
            listAvailableBackups(result);
        }
        if (call.method.equals("restore")) {
            String nodeId = call.argument("nodeId").toString();
            String breezBackupID = call.argument("breezBackupID").toString();
            restore(breezBackupID, nodeId, result);
        }
    }

    private void listAvailableBackups(MethodChannel.Result result){
        try {
            result.success(fetchAppFolders());
        } catch (Exception e) {
            result.error("Failed to backup", e.getMessage(), e.toString());
        }
    }

    private void backup(List<String> paths, String breezBackupID, String nodeId, MethodChannel.Result result) {
        try {
            DriveFolder nodeIDFolder = getOrCreateNodeIdFolder(nodeId);
            ensureBackupIDMatch(nodeIDFolder, breezBackupID);
            uploadBackupFiles(paths, breezBackupID, nodeIDFolder);
            result.success(true);
        }
        catch (BackupConflictException e) {
            Log.e(TAG, e.getMessage(), e);
            result.error(BACKUP_CONFLICT_ERROR_CODE, e.getMessage(), e.toString());
        }
        catch (Exception e) {
            Log.e(TAG, e.getMessage(), e);
            result.error("Failed to backup", e.getMessage(), e.toString());
        }
    }

    private void restore(String breezBackupID, String nodeId, MethodChannel.Result result) {
        try {
            DriveFolder nodeIDFolder = getOrCreateNodeIdFolder(nodeId);
            markBackupID(nodeIDFolder, breezBackupID);
            result.success(downloadBackupFiles(nodeIDFolder));
        }
        catch (BackupConflictException e) {
            Log.e(TAG, e.getMessage(), e);
            result.error(BACKUP_CONFLICT_ERROR_CODE, e.getMessage(), e.toString());
        }
        catch (Exception e) {
            result.error("Failed to restore", e.getMessage(), e.toString());
        }
    }

    private void ensureBackupIDMatch(DriveFolder nodeIDFolder, String breezBackupID) throws Exception{
        Metadata meta = Tasks.await(m_driveResourceClient.getMetadata(nodeIDFolder));
        String existingBreezBackupID = meta.getCustomProperties().get(BREEZ_ID_CUSTOM_PROPERTY);
        if (existingBreezBackupID != null && !breezBackupID.equals(existingBreezBackupID)) {
            throw new BackupConflictException();
        }
    }

    private void markBackupID(DriveFolder nodeIDFolder, String breezBackupID) throws Exception {
        Tasks.await(
                m_driveResourceClient.updateMetadata(
                    nodeIDFolder,
                    new MetadataChangeSet.Builder()
                            .setCustomProperty(BREEZ_ID_CUSTOM_PROPERTY, breezBackupID)
                            .build())
        );
    }

    private DriveFolder getOrCreateNodeIdFolder(String nodeId) throws ExecutionException, InterruptedException {
        DriveFolder appFolder = Tasks.await(m_driveResourceClient.getAppFolder());
        DriveFolder nodeIDFolder = Tasks.await( new GoogleDriveTasks(m_driveResourceClient).getFolderByTitle(appFolder, nodeId) );
        if (nodeIDFolder == null) {
            nodeIDFolder = createNodeFolder(nodeId);
        }
        return nodeIDFolder;
    }

    private DriveFolder createNodeFolder(String nodeId) throws ExecutionException, InterruptedException {
        DriveFolder appFolder = Tasks.await(m_driveResourceClient.getAppFolder());
        MetadataChangeSet changeSet = new MetadataChangeSet.Builder()
                .setTitle(nodeId)
                .setMimeType(DriveFolder.MIME_TYPE)
                .setStarred(true)
                .build();

        return Tasks.await(m_driveResourceClient.createFolder(appFolder, changeSet));
    }


    private HashMap<String, String> fetchAppFolders() throws ExecutionException, InterruptedException {
        DriveFolder appFolder = Tasks.await(m_driveResourceClient.getAppFolder());
        return Tasks.await(new GoogleDriveTasks(m_driveResourceClient).getNestedFolders(appFolder));
    }

    /**upload backup files**/

    private void uploadBackupFiles(List<String> paths, String breezBackupID, DriveFolder nodeIdFolder) throws Exception {
        Log.i(TAG, "updateBackupFiles in nodeID = " + nodeIdFolder.toString());
        GoogleDriveTasks tasksExecutor = new GoogleDriveTasks(m_driveResourceClient);
        UUID uuid = UUID.randomUUID();
        DriveFolder backupFolder = Tasks.await(
                m_driveResourceClient.createFolder(nodeIdFolder,
                        new MetadataChangeSet
                                .Builder()
                                .setTitle(uuid.toString())
                                .build())
        );
        List<Task<DriveFile>> uploadTasks = new ArrayList<Task<DriveFile>>();
        for (String path: paths) {
            uploadTasks.add(tasksExecutor.uploadFile(backupFolder, path));
        }
        List<Task<?>> listTask = Tasks.await(Tasks.whenAllComplete(uploadTasks));
        if (listTask.size() != paths.size()) {
            throw new Exception("Could not upload all backup files");
        }
        for (Task task: listTask) {
            if (!task.isSuccessful()) {
                throw new Exception("Could not upload all backup files");
            }
        }

        MetadataChangeSet changeSet = new MetadataChangeSet.Builder()
                .setCustomProperty(FOLDER_ID_CUSTOM_PROPERTY, uuid.toString())
                .setCustomProperty(BREEZ_ID_CUSTOM_PROPERTY, breezBackupID)
                .build();
        Tasks.await(m_driveResourceClient.updateMetadata(nodeIdFolder, changeSet));
    }


    /**download backup files**/

    private List<String> downloadBackupFiles(DriveFolder nodeIdFolder) throws Exception {
        GoogleDriveTasks tasksExecutor = new GoogleDriveTasks(m_driveResourceClient);
        Metadata nodeIDFolder = Tasks.await(m_driveResourceClient.getMetadata(nodeIdFolder));
        String backupFolderID = nodeIDFolder.getCustomProperties().get(FOLDER_ID_CUSTOM_PROPERTY);
        DriveFolder backupFolder = Tasks.await(tasksExecutor.getFolderByTitle(nodeIdFolder, backupFolderID));
        MetadataBuffer queryBuffer = Tasks.await(m_driveResourceClient.queryChildren(backupFolder, new Query.Builder().build()));
        List<Task<String>> downloadedFiles = new ArrayList<Task<String>>();

        for (Metadata m : queryBuffer) {
            downloadedFiles.add(tasksExecutor.downloadDriveFile(m, m_activity.getCacheDir().getPath()));
        }
        List<Task<?>> tasks = Tasks.await(Tasks.whenAllComplete(downloadedFiles));
        if (tasks.size() != downloadedFiles.size()) {
            throw new Exception("Failed to download all restore files");
        }
        for (Task task: tasks) {
            if (!task.isSuccessful()) {
                throw new Exception("Could not upload all backup files");
            }
        }

        List<String> backupPathsList = new ArrayList<>();
        for (Task<String> downloadedFile : downloadedFiles) {
            backupPathsList.add(downloadedFile.getResult());
        }
        return backupPathsList;

    }

    @Override
    public synchronized void onListen(Object args, final EventChannel.EventSink events){
        Log.i(TAG, "BreezBackup:onListen: args = " + args.toString());
        Map<String, String> streamArguments = (Map<String, String>)args;
        m_eventsListener = new BackupChangesListener(events, streamArguments.get("nodeID"));
        if (m_driveResourceClient != null) {
            registerChangesListener(m_driveResourceClient);
            return;
        }
        new BackupTask(t -> {
            try {
                initDriveResourceClient(true);
            } catch (Exception e) {
                Log.e(TAG, "onListen error " + e.getMessage(), e);
            }
            return null;
        }).execute();
    }

    @Override
    public void onCancel(Object args) {
        m_eventsListener = null;
    }

    private void registerChangesListener(final DriveResourceClient resourceClient){
        Log.i(TAG, "registerChangesListener started");
        new BackupTask(t -> {
            try {
                GoogleDriveTasks tasks = new GoogleDriveTasks(resourceClient);
                DriveFolder appFolder = Tasks.await(resourceClient.getAppFolder());
                DriveFolder nodeFolder = Tasks.await(tasks.getFolderByTitle(appFolder, m_eventsListener.m_nodeID));
                Metadata currentMeta =  Tasks.await(resourceClient.getMetadata(nodeFolder));
                String currentBackupID = currentMeta.getCustomProperties().get(BREEZ_ID_CUSTOM_PROPERTY);
                Log.i(TAG, "registerChangesListener currentBackupID = " + currentBackupID);
                if (currentBackupID != null) {
                    m_eventsListener.m_listener.success(currentBackupID);
                }

                Task<ListenerToken> changesListenerTask = resourceClient.addChangeListener(nodeFolder, changeEvent -> {
                    if (changeEvent.hasMetadataChanged() ||changeEvent.hasBeenDeleted()) {
                        Log.i(TAG, "registerChangesListener: got metadata changes");
                        resourceClient.getMetadata(nodeFolder)
                                .addOnCompleteListener(metadataTask -> {

                                    if (!metadataTask.isSuccessful()) {
                                        Exception e = metadataTask.getException();
                                        Log.e(TAG, "registerChangesListener: failed to get folder metadata", e);
                                        m_eventsListener.m_listener.error("failed get metadata for folder", e.getMessage(), e.toString());
                                        return;
                                    }

                                    Metadata meta = metadataTask.getResult();
                                    String backupID = meta.getCustomProperties().get(BREEZ_ID_CUSTOM_PROPERTY);
                                    Log.i(TAG, "registerChangesListener: current deviceID = " + backupID);
                                    if (backupID != null) {
                                        m_eventsListener.m_listener.success(backupID);
                                    }
                                });
                    }
                });
                ListenerToken token = Tasks.await(changesListenerTask);
                if (resourceClient == m_driveResourceClient) {
                    m_changesToken = token;
                } else {
                    resourceClient.removeChangeListener(token);
                }
            } catch (Exception e) {
                Log.e(TAG, "Failed to register for changes", e);
            }
            return null;
        }).execute();
    }

    private void clearChangesListener(final DriveResourceClient resourceClient){
        if (resourceClient != null) {
            ListenerToken token = m_changesToken;
            if (token != null) {
                resourceClient.removeChangeListener(token);
            }
        }
    }

    private static class BackupTask extends AsyncTask<Object, Integer, Void> {
        Function<Void,Void> m_executor;

        public BackupTask(Function<Void,Void> executor){
            m_executor = executor;
        }
        @Override
        protected Void doInBackground(Object... objects) {
            return m_executor.apply(null);
        }
    }

    private static class BackupChangesListener {
        public final EventChannel.EventSink m_listener;
        public final String m_nodeID;

        public BackupChangesListener(EventChannel.EventSink listener, String nodeID) {
            Log.i(TAG, "BackupChangesListener creates: nodeID = " + nodeID);
            m_listener = listener;
            m_nodeID = nodeID;
        }
    }
}

