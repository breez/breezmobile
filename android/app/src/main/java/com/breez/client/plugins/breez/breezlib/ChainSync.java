package com.breez.client.plugins.breez.breezlib;
import androidx.work.*;
import bindings.Bindings;
import bindings.BreezNotifier;

import android.content.*;
import android.util.Log;

import com.breez.client.BreezApplication;

public class ChainSync extends Worker {

    private static final String TAG = "BREEZSYNC";

    private static boolean sRunning;

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

        Result result = Result.SUCCESS;
        setRunning(true);
        try {
            //if this job was stopped/cancelled, ignore.
            if (isStopped()) {
                Log.i(TAG, "ChainSync job ignored because job is cancelled");
                return Result.SUCCESS;
            }

            String workingDir = getInputData().getString("workingDir");
            Bindings.runSyncJob(workingDir);
        } catch (Exception e) {
            Log.e(TAG, "ChainSync job received error: ",  e);
            result = Result.FAILURE;
        }
        finally {
            setRunning(false);
        }

        Log.i(TAG, "ChainSync job finished with status: " + result.toString());
        return result;
    }

    private Result ensureConnected(){
        Log.i(TAG, "ChainSync job ignored because app is running");
        if (Bindings.daemonReady() && !Bindings.isConnectedToRoutingNode()) {
            Log.i(TAG, "ChainSync job trying to connect and wait...");
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
        if (isRunning()) {
            Bindings.stop();
        }
    }

    public static synchronized void waitShutdown(){
        Log.i(TAG, "ChainSync job wait for shut down");
        if (!sRunning) {
            return;
        }
        try {
            ChainSync.class.wait();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    private static synchronized void setRunning(boolean running) {
        Log.i(TAG, "ChainSync job setRunning = " + running);
        sRunning = running;
        if (!running) {
            ChainSync.class.notifyAll();
        }
    }

    private static synchronized  boolean isRunning(){ return sRunning; }
}
