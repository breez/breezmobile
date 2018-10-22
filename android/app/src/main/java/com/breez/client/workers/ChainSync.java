package com.breez.client.workers;
import androidx.work.*;
import bindings.Bindings;
import bindings.BreezNotifier;

import android.content.*;
import android.content.res.Configuration;
import android.util.Log;

import com.breez.client.BreezApplication;

public class ChainSync extends Worker {

    public static final String TAG = "BREEZJOB";
    private volatile Result m_result = Result.SUCCESS;

    public ChainSync(Context context, WorkerParameters params) {
        super(context, params);
    }

    @Override
    public Worker.Result doWork() {
      try {
          String workingDir = getInputData().getString("workingDir");
          Bindings.runSyncJob(workingDir);
      } catch (Exception e) {
          Log.e(TAG, "Job received error: ",  e);
          m_result = Result.FAILURE;
      }

      Log.e("BREEZJOB", "Job finished with status: " + m_result.toString());
      return m_result;
    }
}
