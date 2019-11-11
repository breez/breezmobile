package com.breez.client;

import com.breez.client.plugins.breez.breezlib.Breez;
import com.breez.client.plugins.breez.*;
import android.os.Bundle;

import android.content.Intent;
import android.nfc.NfcAdapter;
import io.flutter.app.FlutterFragmentActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import android.util.Log;

public class MainActivity extends FlutterFragmentActivity {
    private static final String TAG = "Breez";
    private LifecycleEvents _lifecycleEventsPlugin;
    public boolean isPos = false;
    NfcHandler m_nfc;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.d(TAG, "Breez activity created...");
        BreezApplication.isRunning = true;
        isPos = this.getPackageName().equals("com.breez.client.pos");
        m_nfc = new NfcHandler(this);

        registerBreezPlugins();
        GeneratedPluginRegistrant.registerWith(this);
    }

    @Override
    protected void onDestroy() {
        Log.d(TAG, "Breez activity destroying...");
        super.onDestroy();
        System.exit(0);
    }

    void registerBreezPlugins() {
        BreezApplication.breezShare = new BreezShare(this.registrarFor("com.breez.client.plugins.breez_share"), this);
        new Breez(this.registrarFor("com.breez.client.plugins.breez_lib"));
        _lifecycleEventsPlugin = new LifecycleEvents(this.registrarFor("com.breez.client.plugins.lifecycle_events_notifications"));
        new Permissions(this.registrarFor("com.breez.client.plugins.permissions"), this);        
    }

    public void onPause() {
        super.onPause();
        BreezApplication.isBackground = true;
    }

    public void onResume() {
        super.onResume();
        BreezApplication.isBackground = false;
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        Log.d(TAG, "Got an intent...");

        if (intent != null && (intent.getAction().equals(BreezApduService.ACTION_BOLT11_RECEIVED)
                || intent.getAction().equals(NfcAdapter.ACTION_TAG_DISCOVERED)
                || intent.getAction().equals(NfcAdapter.ACTION_NDEF_DISCOVERED))) {
            m_nfc.handleIntent(intent);
        }
    }
}
