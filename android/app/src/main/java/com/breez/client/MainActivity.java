package com.breez.client;

import com.breez.client.plugins.breez.breezlib.Breez;
import com.breez.client.plugins.breez.*;
import com.ryanheise.audioservice.AudioService;
import com.ryanheise.audioservice.AudioServicePlugin;

import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.android.SplashScreen;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.os.Build;
import android.os.Bundle;
import android.view.WindowManager.LayoutParams;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationManagerCompat;

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
    @Nullable
    public FlutterEngine provideFlutterEngine(@NonNull Context context) {
        return AudioServicePlugin.getFlutterEngine(context);
    }

    @Override
    public void onPause() {
        super.onPause();
        getWindow().addFlags(LayoutParams.FLAG_SECURE);
    }

    @Override
    public void onResume() {
        super.onResume();
        dismissNotification();
        getWindow().clearFlags(LayoutParams.FLAG_SECURE);
    }

    private void dismissNotification() {
        int notificationID = getIntent().getIntExtra("NOTIFICATION_ID", -1);
        if(notificationID != -1) {
            Log.d(TAG, "Cancel notification:" + notificationID);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                NotificationManager notificationManager = getNotificationManager();
                notificationManager.cancel(notificationID);
            } else {
                NotificationManagerCompat notificationManagerCompat = getAdaptedOldNotificationManager();
                notificationManagerCompat.cancel(notificationID);
            }
        }
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
        final PluginRegistry pluginRegistry = flutterEngine.getPlugins();
        pluginRegistry.add(BreezApplication.breezShare);
        pluginRegistry.add(new Breez());
        pluginRegistry.add(new LifecycleEvents());
        pluginRegistry.add(new Permissions());
        pluginRegistry.add(new Tor());
    }

    @Override
    public SplashScreen provideSplashScreen() {
        return null;
    }


    @RequiresApi(Build.VERSION_CODES.O)
    private NotificationManager getNotificationManager() {
        return (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
    }

    private NotificationManagerCompat getAdaptedOldNotificationManager() {
        return NotificationManagerCompat.from(this);
    }
}
