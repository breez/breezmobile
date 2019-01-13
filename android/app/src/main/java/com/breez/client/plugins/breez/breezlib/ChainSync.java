package com.breez.client.plugins.breez.breezlib;
import androidx.work.*;
import bindings.Bindings;
import bindings.JobController;

import android.content.*;
import android.os.Environment;
import android.util.Log;

import com.breez.client.BreezApplication;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.LogManager;
import java.util.logging.Logger;

public class ChainSync extends Worker {

    public static final String UNIQUE_WORK_NAME = "chainSync";
    private static final String TAG = "BREEZSYNC";
    private volatile JobController mJobController;
    private static List<JobController> sJobs = Collections.synchronizedList(new ArrayList());
    private Logger m_logger = Logger.getLogger(TAG);


    public ChainSync(Context context, WorkerParameters params) {
        super(context, params);
    }

    @Override
    public Worker.Result doWork() {
        m_logger.info("ChainSync job started");

        //if breez app is running just ensure connected so sync will be done
        if (BreezApplication.isRunning) {
            return ensureConnected();
        }

        try {
            synchronized (this) {

                //if this job was stopped/cancelled, ignore.
                if (isStopped()) {
                    m_logger.info("ChainSync job ignored because job is cancelled");
                    return Result.SUCCESS;
                }

                try {
                    String workingDir = getInputData().getString("workingDir");
                    if (workingDir == null) {
                        workingDir = new File(getApplicationContext().getDataDir(), "app_flutter").getAbsolutePath();
                    }

                    mJobController = Bindings.newSyncJob(workingDir);
                    mJobController.start();
                    sJobs.add(mJobController);
                } catch (Exception e) {
                    m_logger.log(Level.SEVERE,"ChainSync job received error: ", e);
                    return Result.FAILURE;
                }
            }
            mJobController.waitForShutdown();

            m_logger.info("ChainSync job finished succesfully");
            return Result.SUCCESS;
        }
        finally {
            if (mJobController != null) {
                sJobs.remove(mJobController);
            }
            mJobController = null;
        }
    }

    //In case the app is running in the background, only reconnect to allow the chain to sync.
    private Result ensureConnected(){
        m_logger.info( "ChainSync job only ensures connected because app is running");
        if (Bindings.daemonReady() && !Bindings.isConnectedToRoutingNode()) {
            m_logger.info( "ChainSync job reconnects...");
            try {
                Bindings.connectAccount();
            } catch (Exception e) {
                //just log this error so the WorkManager won't try again
                m_logger.log(Level.SEVERE, "error connecting to account from job", e);
            }
        }
        return Result.SUCCESS;
    }

    @Override
    public void onStopped(boolean cancelled) {
        super.onStopped(cancelled);
        m_logger.info("ChainSync job onStopped called cancelled=: " + cancelled);

        //The stop and start of breez daemon must not overlap, this is why the synchronized block.
        synchronized (this) {
            m_logger.info("ChainSync job onStopped in synchronized block");
            if (mJobController != null) {
                m_logger.info("ChainSync job stopping job");
                stopJob(mJobController);
                m_logger.info("ChainSync job onStopped after stop");
            }
        }
    }

    public static void waitShutdown(){
        Log.i(TAG, "ChainSync job wait for shut down");
        for (JobController job: sJobs) {
            stopJob(job);
            job.waitForShutdown();
        }
    }

    private static void stopJob(JobController controller) {
        try {
            controller.stop();
            sJobs.remove(controller);
        } catch (Exception e) {
            Log.e(TAG, "Failed to stop job " + e.getMessage(), e);
            e.printStackTrace();
        }
    }
}
