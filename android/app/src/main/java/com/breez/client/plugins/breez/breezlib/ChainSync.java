package com.breez.client.plugins.breez.breezlib;
import androidx.work.*;
import bindings.Bindings;

import android.content.*;
import android.util.Log;

import com.breez.client.BreezApplication;

import java.util.logging.Level;
import java.util.logging.LogManager;
import java.util.logging.Logger;

public class ChainSync extends Worker {

    private static final String TAG = "BREEZSYNC";
    private volatile boolean mDaemonIsRunning;
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

        mDaemonIsRunning = true;
        try {
            synchronized (this) {

                //if this job was stopped/cancelled, ignore.
                if (isStopped()) {
                    m_logger.info("ChainSync job ignored because job is cancelled");
                    return Result.SUCCESS;
                }

                try {
                    String workingDir = getInputData().getString("workingDir");
                    Bindings.startSyncJob(workingDir);
                } catch (Exception e) {
                    m_logger.log(Level.SEVERE,"ChainSync job received error: ", e);
                    return Result.FAILURE;
                }
            }
            Bindings.waitDaemonShutdown();

            m_logger.info("ChainSync job finished succesfully");
            return Result.SUCCESS;
        }
        finally {
            mDaemonIsRunning = false;
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
            if (mDaemonIsRunning) {
                Bindings.stop();
                m_logger.info("ChainSync job onStopped after stop");
            }
        }
    }

    public static void waitShutdown(){
        Log.i(TAG, "ChainSync job wait for shut down");
        Bindings.waitDaemonShutdown();
    }
}
