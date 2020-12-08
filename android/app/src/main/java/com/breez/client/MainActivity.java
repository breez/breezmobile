package com.breez.client;

import com.breez.client.plugins.breez.breezlib.Breez;
import com.breez.client.plugins.breez.*;
import android.os.Bundle;

import android.content.Intent;
import android.nfc.NfcAdapter;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import android.util.Log;

import androidx.annotation.NonNull;

public class MainActivity extends FlutterActivity {
    private static final String TAG = "Breez";
    private LifecycleEvents _lifecycleEventsPlugin;
    public boolean isPos = false;
    NfcHandler m_nfc;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        Log.d(TAG, "Breez activity created...");
        BreezApplication.isRunning = true;
        isPos = this.getPackageName().equals("com.breez.client.pos");
        m_nfc = new NfcHandler(this);


        registerBreezPlugins();
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }


    void registerBreezPlugins(@NonNull FlutterEngine flutterEngine) {
        BreezApplication.breezShare = new BreezShare(this.registrarFor("com.breez.client.plugins.breez_share"), this);
        flutterEngine.getPlugins().add(new Breez());
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
}
