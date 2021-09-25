package com.breez.client.plugins.breez.breezlib;

import androidx.work.*;
import bindings.Bindings;
import bindings.ChannelsWatcherJobController;
import bindings.JobController;

import android.content.*;
import com.breez.client.BreezLogger;

import java.io.File;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.concurrent.TimeUnit;

public class ChainSync extends Worker {

    public static final String UNIQUE_WORK_NAME = "chainSync";
    private static final String TAG = "BREEZSYNC";
    private volatile ChannelsWatcherJobController syncJobController;
    private volatile JobController closedchannelsJobController;
    private Logger m_logger;
    private Executor _executor = Executors.newCachedThreadPool();


    public ChainSync(Context context, WorkerParameters params) {
        super(context, params);
        m_logger = BreezLogger.getLogger(context, TAG);
    }

    public static void schedule(){
        final PeriodicWorkRequest.Builder work = new PeriodicWorkRequest.Builder(ChainSync.class, 6, TimeUnit.HOURS, 3, TimeUnit.HOURS)
                .addTag(UNIQUE_WORK_NAME);
        WorkManager.getInstance().enqueueUniquePeriodicWork(UNIQUE_WORK_NAME, ExistingPeriodicWorkPolicy.REPLACE, work.build());
    }

    @Override
    public Worker.Result doWork() {
        m_logger.info("ChainSync job started");

        try {
            synchronized (this) {
                //if this job was stopped/cancelled, ignore.
                if (isStopped()) {
                    m_logger.info("ChainSync job ignored because job is cancelled");
                    return Result.success();
                }

                String workingDir = getInputData().getString("workingDir");
                if (workingDir == null) {
                    workingDir = new File(getApplicationContext().getDataDir(), "app_flutter").getAbsolutePath();
                }

                syncJobController = Bindings.newSyncJob(workingDir);
                closedchannelsJobController = Bindings.newClosedChannelsJob(workingDir);
            }
            boolean channelClosedDetected = syncJobController.run();
            if (channelClosedDetected) {
                Notification.showClosedChannelNotification(getApplicationContext());
            }
            m_logger.info("ChainSync job finished succesfully");
            closedchannelsJobController.run();
            m_logger.info("ClosedChannels job finished succesfully");
            return Result.success();
        } catch (Exception e) {
            m_logger.log(Level.SEVERE,"ChainSync job start received error: ", e);
            return Result.failure();
        } finally {
            syncJobController = null;
            closedchannelsJobController = null;
        }
    }

    @Override
    public void onStopped() {
        super.onStopped();
        m_logger.info("ChainSync job onStopped called");

        //The stop and start of breez daemon must not overlap, this is why the synchronized block.
        synchronized (this) {
            m_logger.info("ChainSync job onStopped in synchronized block");
            final ChannelsWatcherJobController syncController = syncJobController;
            final JobController channelsController = closedchannelsJobController;
            if (syncController != null) {
                _executor.execute(() -> syncController.stop());
            }
            if (channelsController != null) {
                _executor.execute(() -> channelsController.stop());
            }
        }
    }
}
