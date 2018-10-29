package com.breez.client.plugins.breez.breezlib;
import androidx.work.*;
import bindings.Bindings;

import android.content.*;
import android.util.Log;

import com.breez.client.BreezApplication;

public class ChainSync extends Worker {

    private static final String TAG = "BREEZSYNC";
    private volatile boolean mDaemonIsRunning;
    private volatile Result mJobResult;

    public ChainSync(Context context, WorkerParameters params) {
        super(context, params);
    }

    @Override
    public Worker.Result doWork() {
        Log.i(TAG, "ChainSync job started");

        //if breez app is running just ensure connected so sync will be done
        if (BreezApplication.isRunning) {
            return ensureConnected();
        }

        mDaemonIsRunning = true;
        try {
            synchronized (this) {

                //if this job was stopped/cancelled, ignore.
                if (isStopped()) {
                    Log.i(TAG, "ChainSync job ignored because job is cancelled");
                    return Result.SUCCESS;
                }

                try {
                    String workingDir = getInputData().getString("workingDir");
                    Bindings.startSyncJob(workingDir);
                } catch (Exception e) {
                    Log.e(TAG, "ChainSync job received error: ", e);
                    return Result.FAILURE;
                }
            }
            Bindings.waitDaemonShutdown();

            Log.i(TAG, "ChainSync job finished succesfully");
            return Result.SUCCESS;
        }
        finally {
            mDaemonIsRunning = false;
        }
    }

    //In case the app is running in the background, only reconnect to allow the chain to sync.
    private Result ensureConnected(){
        Log.i(TAG, "ChainSync job only ensures connected because app is running");
        if (Bindings.daemonReady() && !Bindings.isConnectedToRoutingNode()) {
            Log.i(TAG, "ChainSync job reconnects...");
            try {
                Bindings.connectAccount();
            } catch (Exception e) {
                //just log this error so the WorkManager won't try again
                Log.e(TAG, "error connecting to account from job", e);
            }
        }
        return Result.SUCCESS;
    }

    @Override
    public void onStopped(boolean cancelled) {
        super.onStopped(cancelled);
        Log.i(TAG, "ChainSync job onStopped called cancelled=: " + cancelled);

        //The stop and start of breez daemon must not overlap, this is why the synchronized block.
        synchronized (this) {
            Log.i(TAG, "ChainSync job onStopped in synchronized block");
            if (mDaemonIsRunning) {
                Bindings.stop();
                Log.i(TAG, "ChainSync job onStopped after stop");
            }
        }
    }

    public static void waitShutdown(){
        Log.i(TAG, "ChainSync job wait for shut down");
        Bindings.waitDaemonShutdown();
    }
}
