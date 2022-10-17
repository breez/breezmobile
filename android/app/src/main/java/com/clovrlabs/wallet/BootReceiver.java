package com.clovrlabs.wallet;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.clovrlabs.wallet.plugins.breez.breezlib.ChainSync;

public class BootReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(final Context context, final Intent intent) {
        if (Intent.ACTION_BOOT_COMPLETED.equals(intent.getAction())) {
            ChainSync.schedule();
            Log.i("CLOVRBT", "Succesfully registered periodic sync after boot");
        }
    }
}
