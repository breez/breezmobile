package com.breez.client;

import com.breez.client.plugins.breez.breezlib.Breez;
import com.breez.client.plugins.breez.*;
import com.ryanheise.audioservice.AudioService;

import android.content.Intent;
import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.android.SplashScreen;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
import android.view.WindowManager.LayoutParams;
import android.util.Log;

import androidx.annotation.NonNull;

public class MainActivity extends FlutterFragmentActivity {
    private static final String TAG = "Breez";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        Log.d(TAG, "Breez activity created...");
        BreezApplication.isRunning = true;

        registerBreezPlugins(flutterEngine);
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }

    @Override
    public void onPause() {
        super.onPause();
        getWindow().addFlags(LayoutParams.FLAG_SECURE);
    }

    @Override
    public void onResume() {
        super.onResume();
        getWindow().clearFlags(LayoutParams.FLAG_SECURE);
    }

    @Override
    protected void onDestroy() {
        Log.d(TAG, "Breez activity destroyed...");
        super.onDestroy();
        stopService(new Intent(this, AudioService.class));
        System.exit(0);
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
