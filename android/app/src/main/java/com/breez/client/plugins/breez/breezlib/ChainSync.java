package com.breez.client.plugins.breez.breezlib;
import androidx.work.*;
import bindings.Bindings;
import bindings.JobController;

import android.content.*;
import android.os.Environment;
import android.util.Log;

import com.breez.client.BreezApplication;
import com.breez.client.BreezLogger;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;
import java.util.logging.Level;
import java.util.logging.LogManager;
import java.util.logging.Logger;

public class ChainSync extends Worker {

    public static final String UNIQUE_WORK_NAME = "chainSync";
    private static final String TAG = "BREEZSYNC";
    private volatile JobController syncJobController;
    private volatile JobController closedchannelsJobController;
    private Logger m_logger;
    private Executor _executor = Executors.newCachedThreadPool();


    public ChainSync(Context context, WorkerParameters params) {
        super(context, params);
        m_logger = BreezLogger.getLogger(context, TAG);
    }

    @Override
    public Worker.Result doWork() {
        m_logger.info("ChainSync job started");

        try {
            synchronized (this) {
                //if this job was stopped/cancelled, ignore.
                if (isStopped()) {
                    m_logger.info("ChainSync job ignored because job is cancelled");
                    return Result.SUCCESS;
                }

                String workingDir = getInputData().getString("workingDir");
                if (workingDir == null) {
                    workingDir = new File(getApplicationContext().getDataDir(), "app_flutter").getAbsolutePath();
                }

                syncJobController = Bindings.newSyncJob(workingDir);
                closedchannelsJobController = Bindings.newClosedChannelsJob(workingDir);
            }
            syncJobController.run();
            m_logger.info("ChainSync job finished succesfully");
            closedchannelsJobController.run();
            m_logger.info("ClosedChannels job finished succesfully");
            return Result.SUCCESS;
        } catch (Exception e) {
            m_logger.log(Level.SEVERE,"ChainSync job start received error: ", e);
            return Result.FAILURE;
        } finally {
            syncJobController = null;
            closedchannelsJobController = null;
        }
    }

    @Override
    public void onStopped(boolean cancelled) {
        super.onStopped(cancelled);
        m_logger.info("ChainSync job onStopped called cancelled=: " + cancelled);

        //The stop and start of breez daemon must not overlap, this is why the synchronized block.
        synchronized (this) {
            m_logger.info("ChainSync job onStopped in synchronized block");
            if (syncJobController != null) {
                _executor.execute(() -> syncJobController.stop());
                _executor.execute(() -> closedchannelsJobController.stop());
            }
        }
    }
}
