package com.breez.client.plugins.breez.breezlib;
import androidx.work.*;
import bindings.Bindings;

import android.content.*;
import android.util.Log;

import com.breez.client.BreezApplication;

public class ChainSync extends Worker {

    public static final String TAG = "BREEZSYNC";
    private static volatile boolean mRunning;

    public ChainSync(Context context, WorkerParameters params) {
        super(context, params);
    }

    @Override
    public Worker.Result doWork() {
        Log.i(TAG, "ChainSync job started");
        Result result = Result.SUCCESS;
        setRunning(true);
        try {
            //if breez app is running ignore this job
            if (BreezApplication.isRunning) {
                Log.i(TAG, "ChainSync job ignored because app is running");
                return Result.RETRY;
            }

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

    @Override
    public void onStopped(boolean cancelled) {
        Log.i(TAG, "ChainSync job onStopped called cancelled=: " + cancelled);  
        //left these lines commented deliberately untill the right changes will be impemented in breez lib.
              
    //    try {
    //        Bindings.stop();
    //    }
    //    catch(Exception e) {
    //        Log.e(TAG, "ChainSync job Bindings.stop has thrown exception: ",  e);
    //    }
    }

    public static synchronized void waitShutdown(){
        if (!mRunning) {
            return;
        }
        try {
            ChainSync.class.wait();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    private static synchronized void setRunning(boolean running) {
        mRunning = running;
        if (!running) {
            ChainSync.class.notifyAll();
        }
    }
}
