package com.breez.client.job;

import com.breez.client.plugins.breez.breezlib.ChainSync;
import androidx.work.Constraints;
import androidx.work.OneTimeWorkRequest;
import androidx.work.WorkManager;

import static com.breez.client.plugins.breez.breezlib.ChainSync.UNIQUE_WORK_NAME;

public class JobManager {

    public static JobManager instance = new JobManager();

    private JobManager(){}

    public void enqueJob(String workName) throws Exception {
        switch (workName) {
            case UNIQUE_WORK_NAME:
                startSyncJob();
                return;
            default:
                throw new Exception("There is no associated work with " + workName);
        }
    }

    private void startSyncJob(){
        OneTimeWorkRequest oneTime = new OneTimeWorkRequest.Builder(ChainSync.class)
                .setConstraints(
                        new Constraints.Builder()
                                .setRequiresBatteryNotLow(true)
                                .build())
                .build();

        WorkManager.getInstance().enqueue(oneTime);        
    }
}
