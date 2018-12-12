package com.breez.client.plugins.breez.backup;

import android.util.Log;

import com.google.android.gms.drive.DriveContents;
import com.google.android.gms.drive.DriveFile;
import com.google.android.gms.drive.DriveFolder;
import com.google.android.gms.drive.DriveResource;
import com.google.android.gms.drive.DriveResourceClient;
import com.google.android.gms.drive.Metadata;
import com.google.android.gms.drive.MetadataBuffer;
import com.google.android.gms.drive.MetadataChangeSet;
import com.google.android.gms.drive.metadata.CustomPropertyKey;
import com.google.android.gms.drive.query.Filters;
import com.google.android.gms.drive.query.Query;
import com.google.android.gms.drive.query.SearchableField;
import com.google.android.gms.drive.query.SortOrder;
import com.google.android.gms.drive.query.SortableField;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.Tasks;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Iterator;

public class GoogleDriveTasks {
    DriveResourceClient m_driveResourceClient;

    public GoogleDriveTasks(DriveResourceClient client) {
        m_driveResourceClient = client;
    }

    public Task<DriveFile> uploadFile(DriveFolder nodeIdFolder, String path){
        return m_driveResourceClient.createContents()
                .continueWithTask(task -> {
                    DriveContents contents = task.getResult();
                    OutputStream outputStream = contents.getOutputStream();

                    File file = new File(path);
                    FileInputStream inputStream = new FileInputStream(file);

                    int len;
                    byte[] buf = new byte[1024];
                    while ((len = inputStream.read(buf)) > 0) {
                        outputStream.write(buf, 0, len);
                    }

                    MetadataChangeSet changeSet = new MetadataChangeSet.Builder()
                            .setTitle(file.getName())
                            .setMimeType("text/plain")
                            .setStarred(true)
                            .build();

                    return m_driveResourceClient.createFile(nodeIdFolder, changeSet, contents);
                })
                .continueWith(file -> {
                    if (file.isSuccessful()) {
                        Log.i("BreezBackup", "Succesfully uploaded backup file: " + path);
                        return file.getResult();
                    }
                    Log.i("BreezBackup", "Failed to uploaded backup file: " + path);
                    throw file.getException();
                });
    }

    public Task<String> downloadDriveFile(Metadata m, String dirPath){
        return m_driveResourceClient.openFile(m.getDriveId().asDriveFile(), DriveFile.MODE_READ_ONLY)
                .continueWith(contentTask -> {
                    DriveContents fileContents = contentTask.getResult();
                    InputStream remoteFileInputStream = fileContents.getInputStream();

                    File file = new File(dirPath + "/" + m.getTitle());
                    FileOutputStream outputStream = null;

                    try {
                        outputStream = new FileOutputStream(file);
                        int len;
                        byte[] buf = new byte[1024];
                        while ((len = remoteFileInputStream.read(buf)) > 0) {
                            outputStream.write(buf, 0, len);
                        }
                    } catch (IOException e) {
                        Log.e("IO_ERROR", "Couldn't write to cache", null);
                        throw e;
                    }

                    return file.getAbsolutePath();
                })
                .continueWith(path -> {
                    if (path.isSuccessful()) {
                        Log.i("BreezBackup", "Succesfully downloaded backup file: " + m.getTitle());
                        return path.getResult();
                    }
                    Log.i("BreezBackup", "Failed to download backup file: " + m.getTitle());
                    throw path.getException();
                });
    }


    public Task<HashMap<String, String>> getNestedFolders(DriveFolder parent){
        SortOrder ascendingDateOrder = new SortOrder.Builder().addSortAscending(SortableField.MODIFIED_DATE).build();
        Query query = new Query.Builder()
                .addFilter(Filters.eq(SearchableField.MIME_TYPE, DriveFolder.MIME_TYPE))
                .setSortOrder(ascendingDateOrder)
                .build();

        Task<MetadataBuffer> queryTask = m_driveResourceClient.queryChildren(parent, query);

        return  queryTask.continueWith(metadataBufferTask -> {
            HashMap<String, String> foldersMap = new HashMap<>();
            for (Metadata m : queryTask.getResult()) {
                foldersMap.put(m.getTitle(), m.getModifiedDate().toString());
            }
            return foldersMap;
        });
    }

    public Task<DriveFolder> getFolderByTitle(DriveFolder parent, String title) {
        SortOrder descendingDateOrder = new SortOrder.Builder().addSortDescending(SortableField.MODIFIED_DATE).build();
        Query query = new Query.Builder()
                .addFilter(Filters.eq(SearchableField.MIME_TYPE, DriveFolder.MIME_TYPE))
                .addFilter(Filters.eq(SearchableField.TITLE, title))
                .setSortOrder(descendingDateOrder)
                .build();

        Task<MetadataBuffer> queryTask = m_driveResourceClient.queryChildren(parent, query);
        return queryTask.continueWith(childrenTask -> {
            MetadataBuffer res = childrenTask.getResult();
            if (res.getCount() == 0) {
                return null;
            }
            return childrenTask.getResult().get(0).getDriveId().asDriveFolder();
        });
    }
}
