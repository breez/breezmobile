package com.breez.client;

import com.breez.client.plugins.breez.breezlib.Breez;
import com.breez.client.plugins.breez.*;
import android.os.Bundle;

import android.content.Intent;
import android.nfc.NfcAdapter;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.android.SplashScreen;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import android.util.Log;

import androidx.annotation.NonNull;

public class MainActivity extends FlutterFragmentActivity {
    private static final String TAG = "Breez";
    private LifecycleEvents _lifecycleEventsPlugin;
    public boolean isPos = false;
    NfcHandler m_nfc;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        Log.d(TAG, "Breez activity created...");
        BreezApplication.isRunning = true;


        registerBreezPlugins(flutterEngine);
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }


    void registerBreezPlugins(@NonNull FlutterEngine flutterEngine) {
        flutterEngine.getPlugins().add(new NfcHandler());
        BreezApplication.breezShare = new BreezShare();
        flutterEngine.getPlugins().add(BreezApplication.breezShare);
        flutterEngine.getPlugins().add(new Breez());
        flutterEngine.getPlugins().add(new LifecycleEvents());
        flutterEngine.getPlugins().add(new Permissions());
    }

    @Override
    public SplashScreen provideSplashScreen() {
        return null;
    }
}
