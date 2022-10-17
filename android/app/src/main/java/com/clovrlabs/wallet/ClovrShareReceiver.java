package com.clovrlabs.wallet;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class ClovrShareReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        if (ClovrApplication.breezShare != null) {
            ClovrApplication.breezShare.onChooserResult();
        }
    }
}
