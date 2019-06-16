package com.breez.client;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class BreezShareReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        if (BreezApplication.breezShare != null) {
            BreezApplication.breezShare.onChooserResult();
        }
    }
}
