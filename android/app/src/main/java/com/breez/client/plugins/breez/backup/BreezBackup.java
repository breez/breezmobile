package com.breez.client.plugins.breez.backup;

import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.support.annotation.NonNull;
import android.util.Log;

import com.breez.client.BreezLogger;
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
import java.util.Timer;
import java.util.TimerTask;
import java.util.UUID;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.function.Function;
import java.util.logging.Logger;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

import static android.app.Activity.RESULT_OK;

public class BreezBackup implements MethodChannel.MethodCallHandler {
    public static final String BREEZ_BACKUP_CHANNEL_NAME = "com.breez.client/backup";
    public static final String SIGN_IN_FAILED_CODE = "SIGN_IN_FAILED";
    public static final String BACKUP_CONFLICT_ERROR_CODE = "BACKUP_CONFLICT_ERROR";

    private static final CustomPropertyKey BREEZ_ID_CUSTOM_PROPERTY = new CustomPropertyKey("backupBeezID", CustomPropertyKey.PUBLIC);
    private static final CustomPropertyKey FOLDER_ID_CUSTOM_PROPERTY = new CustomPropertyKey("backupFolderID", CustomPropertyKey.PUBLIC);

    private static final String TAG = "BreezBackup";
    private final Activity m_activity;
    private GoogleAuthenticator m_authenticator;
    private volatile DriveResourceClient m_driveResourceClient;
    DriveClient m_driveClient;
    private long m_lastSyncTime = 0;
    private Executor _executor = Executors.newCachedThreadPool();
    private Logger m_logger;

    public BreezBackup(PluginRegistry.Registrar registrar, Activity activity) {
        this.m_activity = activity;
        new MethodChannel(registrar.messenger(), BREEZ_BACKUP_CHANNEL_NAME).setMethodCallHandler(this);
        m_authenticator = new GoogleAuthenticator(registrar);
        m_logger = BreezLogger.getLogger(activity.getApplicationContext(), TAG);
    }

    @Override
    public void onMethodCall(final MethodCall call, final MethodChannel.Result result) {
        Log.i(TAG, "onMethodCall: " + call.method);

        Boolean silent = call.argument("silent");
        _executor.execute(() -> {
            if (call.method.equals("signOut")) {
                signOut(result);
                return;
            }

            if (call.method.equals("signIn")) {
                signIn(result);
                return;
            }

            try {
                initDriveResourceClient(silent != null && silent.booleanValue());
                handleMethodCall(call, result);
            }
            catch(SignInFailedException e) {
                result.error(SIGN_IN_FAILED_CODE, e.getMessage(), e.toString());
            }
            catch(Exception e) {
                Log.e(TAG, "Unhandled Error " + e.getMessage(), e);
                result.error("Unhandled Error", e.getMessage(), e.toString());
            }
        });
    }

    public void executeBackup(List<String> paths, String breezBackupID, String nodeId ) throws Exception {
        try {
            m_logger.info("backing up files started");
            initDriveResourceClient(true);
            uploadFiles(paths, breezBackupID, nodeId);
        }
        catch(Exception e) {
            Log.e(TAG,"failed in executeBackup", e);
            throw e;
        }
    }

    private synchronized DriveResourceClient initDriveResourceClient(boolean silent) throws Exception{
        try {            
            if (m_driveResourceClient == null) {
                m_logger.info("initDriveResourceClient m_driveResourceClient is null, initializing...");
                GoogleSignInAccount loggedInAccount = Tasks.await(m_authenticator.ensureSignedIn(silent));
                m_driveClient = Drive.getDriveClient(m_activity, loggedInAccount);                
                m_driveResourceClient = Drive.getDriveResourceClient(m_activity, loggedInAccount);
            }            
            return m_driveResourceClient;
        }
        catch(ExecutionException e) {
            if (e.getCause() instanceof Exception){
                throw (Exception)e.getCause();
            }
            throw e;
        }
    }

    private synchronized void destroyDriveResourceClient(){
        if (m_driveResourceClient != null) {
            m_driveResourceClient = null;
        }
    }

    private void signIn(MethodChannel.Result result) {
        try {
            destroyDriveResourceClient();
            initDriveResourceClient(false);            
            m_logger.info("signIn completed");
            result.success(true);
        } catch (Exception e) {
            result.error("signIn failed", e.getMessage(), null);
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
        if (call.method.equals("getAvailableBackups")) {
            listAvailableBackups(result);
        }
        if (call.method.equals("restore")) {
            String nodeId = call.argument("nodeId").toString();
            String breezBackupID = call.argument("breezBackupID").toString();
            restore(breezBackupID, nodeId, result);
        }
        if (call.method.equals("isSafeForBreezBackupID")) {
            String nodeId = call.argument("nodeId").toString();
            String breezBackupID = call.argument("breezBackupID").toString();
            isSafeForBreezBackupID(breezBackupID, nodeId, result);
        }
    }

    private void listAvailableBackups(MethodChannel.Result result){
        try {
            safeRequestSync();
            result.success(fetchAppFolders());
        } catch (Exception e) {
            result.error("Failed to backup", e.getMessage(), e.toString());
        }
    }

    private void uploadFiles(List<String> paths, String breezBackupID, String nodeId) throws Exception {
        DriveFolder nodeIDFolder = getOrCreateNodeIdFolder(nodeId);
        m_logger.info("backup fetched node id folder");
        uploadBackupFiles(paths, breezBackupID, nodeIDFolder);
    }

    private void restore(String breezBackupID, String nodeId, MethodChannel.Result result) {
        try {
            DriveFolder nodeIDFolder = getOrCreateNodeIdFolder(nodeId);
            markBackupID(nodeIDFolder, breezBackupID);
            result.success(downloadBackupFiles(nodeIDFolder));            
        }
        catch (Exception e) {
            Log.e(TAG, e.getMessage(), e);
            result.error("Failed to restore", e.getMessage(), e.toString());
        }
    }

    private void isSafeForBreezBackupID(String breezBackupID, String nodeId, MethodChannel.Result result){
        try {            
            DriveFolder nodeFolder = getOrCreateNodeIdFolder(nodeId);
            Log.i(TAG, "isSafeForBreezBackupID nodeID = " + nodeId + " breezBackupID = " + breezBackupID);
            ensureBackupIDMatch(nodeFolder, breezBackupID);
            result.success(true);
        }
        catch (BackupConflictException e) {
            Log.e(TAG, e.getMessage(), e);
            result.error(BACKUP_CONFLICT_ERROR_CODE, e.getMessage(), e.toString());
        }
        catch (Exception e) {
            Log.e(TAG, e.getMessage(), e);
            result.error("Failed to check isSafeForBreezBackupID", e.getMessage(), e.toString());
        }
    }

    private void safeRequestSync(){
        try {
            long start = System.currentTimeMillis();
            if (start - m_lastSyncTime > 60 * 1000) {
                Tasks.await(m_driveClient.requestSync());
                m_lastSyncTime = System.currentTimeMillis();
                Log.i(TAG, "requestSync was called and took: " + (m_lastSyncTime - start) + " milliseconds");
            }
        }
        catch(Exception e) {
            Log.e(TAG, "safeRequestSync error: " + e.getMessage(), e);
        }
    }

    private void ensureBackupIDMatch(DriveFolder nodeIDFolder, String breezBackupID) throws Exception{
        Metadata meta = Tasks.await(m_driveResourceClient.getMetadata(nodeIDFolder));
        String existingBreezBackupID = meta.getCustomProperties().get(BREEZ_ID_CUSTOM_PROPERTY);        
        if (existingBreezBackupID != null && !breezBackupID.equals(existingBreezBackupID)) {
            Log.i(TAG, "isSafeForBreezBackupID detected conflict. existingBreezBackupID = " + existingBreezBackupID + " breezBackupID = " + breezBackupID);
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
                .build();
        
        return Tasks.await(m_driveResourceClient.createFolder(appFolder, changeSet));
    }


    private HashMap<String, String> fetchAppFolders() throws ExecutionException, InterruptedException {
        DriveFolder appFolder = Tasks.await(m_driveResourceClient.getAppFolder());
        return Tasks.await(new GoogleDriveTasks(m_driveResourceClient).getNestedFolders(appFolder));
    }

    private void deleteStaleBackups(DriveFolder nodeFolder, String activeBackupFolderTitle) throws Exception{
        Query query = new Query.Builder()
                .addFilter(Filters.eq(SearchableField.MIME_TYPE, DriveFolder.MIME_TYPE))
                .addFilter(Filters.not(Filters.eq(SearchableField.TITLE, activeBackupFolderTitle)))
                .build();

        MetadataBuffer metaBuffer = Tasks.await(m_driveResourceClient.queryChildren(nodeFolder, query));
        for (Metadata metadata : metaBuffer) {
            Tasks.await(m_driveResourceClient.delete(metadata.getDriveId().asDriveResource()));
        }
    }

    /**upload backup files**/

    private synchronized void uploadBackupFiles(List<String> paths, String breezBackupID, DriveFolder nodeIdFolder) throws Exception {
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
            m_logger.info("adding upload task " + path);
            uploadTasks.add(tasksExecutor.uploadFile(backupFolder, path));
        }
        List<Task<?>> listTask = Tasks.await(Tasks.whenAllComplete(uploadTasks));
        m_logger.info("upload tasks = " + listTask.size());
        if (listTask.size() != paths.size()) {
            throw new Exception("Could not upload all backup files");
        }
        for (Task task: listTask) {
            if (!task.isSuccessful()) {
                m_logger.info("upload tasks is not succesfull");
                throw new Exception("Could not upload all backup files");
            }
        }

        m_logger.info("Deleting stale backup folders");
        deleteStaleBackups(nodeIdFolder, uuid.toString());        
    }


    /**download backup files**/

    private List<String> downloadBackupFiles(DriveFolder nodeIdFolder) throws Exception {        
        GoogleDriveTasks tasksExecutor = new GoogleDriveTasks(m_driveResourceClient);
        Metadata nodeIDFolder = Tasks.await(m_driveResourceClient.getMetadata(nodeIdFolder));
        String backupFolderID = nodeIDFolder.getCustomProperties().get(FOLDER_ID_CUSTOM_PROPERTY);
        m_logger.info("Download backpup files from backupFolderID = " + backupFolderID + " nodeIDFolder = " + nodeIDFolder);
        DriveFolder backupFolder = Tasks.await(tasksExecutor.getFolderByTitle(nodeIdFolder, backupFolderID));
        MetadataBuffer queryBuffer = Tasks.await(m_driveResourceClient.queryChildren(backupFolder, new Query.Builder().build()));
        List<Task<String>> downloadedFiles = new ArrayList<Task<String>>();
        m_logger.info("starting to download files count = " + queryBuffer.getCount());
        for (Metadata m : queryBuffer) {
            m_logger.info("Download backpup file " + m.getTitle() + " size=" + m.getFileSize());
            downloadedFiles.add(tasksExecutor.downloadDriveFile(m, m_activity.getCacheDir().getPath()));
        }

        List<Task<?>> tasks = Tasks.await(Tasks.whenAllComplete(downloadedFiles));
        m_logger.info("finished download tasks.size() = " + tasks.size());
        if (tasks.size() != downloadedFiles.size()) {
            throw new Exception("Failed to download all restored files");
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
}

