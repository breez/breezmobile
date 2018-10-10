package com.breez.client.plugins.breez;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import com.breez.client.BreezApplication;

import static com.breez.client.plugins.breez.BreezShare.BREEZ_SHARE_REQUEST;

public class BreezShareReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        BreezApplication.breezShare.onChooserResult();
    }
}