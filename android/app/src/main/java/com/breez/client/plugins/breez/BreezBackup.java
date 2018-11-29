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
import com.google.android.gms.drive.Metadata;
import com.google.android.gms.drive.MetadataBuffer;
import com.google.android.gms.drive.MetadataChangeSet;
import com.google.android.gms.drive.query.Filters;
import com.google.android.gms.drive.query.Query;
import com.google.android.gms.drive.query.SearchableField;
import com.google.android.gms.drive.query.SortOrder;
import com.google.android.gms.drive.query.SortableField;
import com.google.android.gms.tasks.Task;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
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

    private final int AUTHORIZE_ACTIVITY_REQUEST_CODE = 84;
    private final Activity m_activity;

    private MethodChannel m_methodChannel;
    private MethodCall m_call;
    private MethodChannel.Result m_result;

    private GoogleSignInClient m_googleSignInClient;
    private DriveResourceClient m_driveResourceClient;

    public BreezBackup(PluginRegistry.Registrar registrar, Activity activity) {
        this.m_activity = activity;
        m_methodChannel = new MethodChannel(registrar.messenger(), BREEZ_BACKUP_CHANNEL_NAME);
        m_methodChannel.setMethodCallHandler(this);

        registrar.addActivityResultListener(this);

        m_googleSignInClient = buildGoogleSignInClient();
        getDriveClients(m_googleSignInClient.silentSignIn());
    }

    private GoogleSignInClient buildGoogleSignInClient() {
        GoogleSignInOptions signInOptions =
            new GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
                .requestScopes(Drive.SCOPE_APPFOLDER)
                .build();
        return GoogleSignIn.getClient(m_activity, signInOptions);
    }

    private void getDriveClients(Task<GoogleSignInAccount> signInTask) {
        Log.i(TAG, "Trying to execute sign in task");
        signInTask.addOnSuccessListener(
            googleSignInAccount -> {
                Log.i(TAG, "Sign in success");
                m_driveResourceClient =
                        Drive.getDriveResourceClient(m_activity, googleSignInAccount);
                if (m_call != null) {
                    handleMethodCall(m_call, m_result);
                }
            })
            .addOnFailureListener(
                e -> {
                    Log.w(TAG, "Sign in failed", e);
                    if (m_result != null) {
                        m_result.error("SIGN_IN_FAILURE", "Unable to sign in", null);
                    }
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

    private void promptToAuthorize() {
        Intent signInIntent = m_googleSignInClient.getSignInIntent();
        m_activity.startActivityForResult(signInIntent, AUTHORIZE_ACTIVITY_REQUEST_CODE);
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (m_driveResourceClient == null) {
            m_result = result;
            m_call = call;
            promptToAuthorize();
        }
        else {
            handleMethodCall(call, result);
        }
    }

    private void handleMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("backup")) {
            List<String> paths = call.argument("paths");
            String nodeId = call.argument("nodeId").toString();
            createNodeIdFolder(paths, nodeId, result);
        }
        if (call.method.equals("restore")) {
            String nodeId = call.argument("nodeId").toString();
            if (nodeId.isEmpty()) {
                listBackupFolders(result);
            } else {
                getNodeIdFolder(nodeId, result);
            }
        }
    }

    private void updateBackupFiles(List<String> paths, DriveFolder nodeIdFolder, MethodChannel.Result result) {
        for (String path: paths) {
            m_driveResourceClient.createContents()
                .continueWithTask(task -> {
                    DriveContents contents = task.getResult();
                    OutputStream outputStream = contents.getOutputStream();

                    File file = new File(path);
                    FileInputStream inputStream = new FileInputStream(file);

                    int i;
                    do {
                        byte[] buf = new byte[1024];
                        i = inputStream.read(buf);
                        outputStream.write(buf);
                    } while (i != -1);

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
                    result.error("CREATE_FILE_FAILURE", "Unable to create file", null);
                });
        }
    }

    private void createNodeIdFolder(List<String> paths, String nodeId, MethodChannel.Result result) {
        if (m_driveResourceClient == null) {
            result.error("DRIVE_RESOURCE_FAILURE", "Drive resource client not initialized", null);
            return;
        }

        m_driveResourceClient
                .getAppFolder().addOnFailureListener(m_activity, e -> {
            Log.e(TAG, "Unable to get app folder", e);
            result.error("APP_FOLDER_FAILURE", "Unable to get app folder", null);
        })
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
                        updateBackupFiles(paths, driveFolder, result);
                    })
            .addOnFailureListener(m_activity, e -> {
                Log.e(TAG, "Unable to create folder", e);
                result.error("CREATE_FOLDER_FAILURE", "Unable to create folder", null);
            });
    }

    private void listBackupFolders(MethodChannel.Result result) {
        m_driveResourceClient
            .getAppFolder()
            .continueWithTask(task -> {
                DriveFolder appFolder = task.getResult();

                SortOrder ascendingDateOrder = new SortOrder.Builder().addSortAscending(SortableField.MODIFIED_DATE).build();
                Query query = new Query.Builder()
                    .addFilter(Filters.eq(SearchableField.MIME_TYPE, DriveFolder.MIME_TYPE))
                    .setSortOrder(ascendingDateOrder)
                    .build();

                Task<MetadataBuffer> queryTask = m_driveResourceClient.queryChildren(appFolder, query);

                return  queryTask
                    .addOnSuccessListener(m_activity,
                        metadataBuffer -> {
                            Log.w(TAG, metadataBuffer.toString());
                            if (metadataBuffer.getCount() == 0) {
                                // Notify user there is no data
                                result.error("NO_DATA_ERROR", "No backup folders found", null);
                            }

                            HashMap<String, String> backupsMap = new HashMap<>();

                            for (Metadata m : metadataBuffer) {
                                backupsMap.put(m.getTitle(), m.getModifiedDate().toString());
                            }

                            if (backupsMap.values().size() == 1) {
                                backupsMap.forEach((k, v) -> getNodeIdFolder(k, result));
                            }
                            else {
                                result.success(backupsMap);
                            }
                        })
                    .addOnFailureListener(m_activity, e -> {
                        Log.e(TAG, "Error retrieving files", e);
                        result.error("GET_DATA_FAILURE", "Error retrieving files", null);
                    });
            });
    }

    private void getNodeIdFolder(String nodeId, MethodChannel.Result result) {
        m_driveResourceClient
            .getAppFolder()
            .continueWithTask(task -> {
                DriveFolder appFolder = task.getResult();
                SortOrder descendingDateOrder = new SortOrder.Builder().addSortDescending(SortableField.MODIFIED_DATE).build();

                Query query = new Query.Builder()
                    .addFilter(Filters.eq(SearchableField.MIME_TYPE, DriveFolder.MIME_TYPE))
                    .addFilter(Filters.eq(SearchableField.TITLE, nodeId))
                    .setSortOrder(descendingDateOrder)
                    .build();

                Task<MetadataBuffer> queryTask = m_driveResourceClient.queryChildren(appFolder, query);
                return  queryTask
                    .addOnSuccessListener(m_activity,
                        metadataBuffer -> {
                            Log.w(TAG, metadataBuffer.toString());
                            if (metadataBuffer.getCount() == 0) {
                                result.error("NODE_ID_BACKUP_NOT_FOUND", "Couldn't find node ID backup", null);
                            }

                            fetchBackupFiles(metadataBuffer.get(0).getDriveId().asDriveFolder(), result);
                        })
                    .addOnFailureListener(m_activity, e -> {
                        Log.e(TAG, "Error retrieving files", e);
                        result.error("GET_DATA_FAILURE", "Error retrieving files", null);
                    });
            });
    }

    private void fetchBackupFiles(DriveFolder nodeIdFolder, MethodChannel.Result result) {
        List<String> backupPathsList = new ArrayList<>();
        Query query = new Query.Builder()
                .build();

        Task<MetadataBuffer> queryTask = m_driveResourceClient.queryChildren(nodeIdFolder, query);

        queryTask
            .addOnSuccessListener(m_activity,
                metadataBuffer -> {
                    for (Metadata m : metadataBuffer) {
                        m_driveResourceClient.openFile(m.getDriveId().asDriveFile(), DriveFile.MODE_READ_ONLY)
                                .addOnSuccessListener(contents -> {
                            DriveContents fileContents = contents;
                            InputStream remoteFileInputStream = fileContents.getInputStream();

                            File file = new File(m_activity.getCacheDir().getPath() + "/" + m.getTitle());
                            FileOutputStream outputStream = null;

                            try {
                                outputStream = new FileOutputStream(file);
                            } catch (FileNotFoundException e) {
                                result.error("CACHE_FILE_FAILURE", "Couldn't find cache file to save to", null);
                            }

                            try {
                                int i;
                                do {
                                    byte[] buf = new byte[1024];
                                    i = remoteFileInputStream.read(buf);
                                    outputStream.write(buf);
                                } while (i != -1);
                            } catch (IOException e) {
                                result.error("IO_ERROR", "Couldn't write to cache", null);
                            }

                            backupPathsList.add(file.getAbsolutePath());

                            if (backupPathsList.size() == metadataBuffer.getCount()) {
                                result.success(backupPathsList);
                            }
                        });
                    }
                })
                .addOnFailureListener(m_activity, e -> {
                    result.error("QUERY_FAILURE", "Querying folder for files failed", null);
                });
    }
}

