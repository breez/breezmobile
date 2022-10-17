package com.clovrlabs.wallet;

import com.clovrlabs.wallet.plugins.breez.breezlib.Breez;
import com.clovrlabs.wallet.plugins.breez.*;

import android.app.NotificationManager;
import android.content.Context;

import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.android.SplashScreen;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.os.Build;
import android.view.WindowManager.LayoutParams;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationManagerCompat;

public class MainActivity extends FlutterFragmentActivity {
    private static final String TAG = "Clovr";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(this.getFlutterEngine());
        setTheme(R.style.LaunchTheme);
        Log.d(TAG, "Breez activity created...");
        ClovrApplication.isRunning = true;

        registerBreezPlugins(flutterEngine);
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
        if (notificationID != -1) {
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
        Log.d(TAG, "Clovr activity destroyed...");
        super.onDestroy();
        System.exit(0);
    }

    void registerBreezPlugins(@NonNull FlutterEngine flutterEngine) {
        flutterEngine.getPlugins().add(new NfcHandler());
        ClovrApplication.breezShare = new BreezShare();
        flutterEngine.getPlugins().add(ClovrApplication.breezShare);
        flutterEngine.getPlugins().add(new Breez());
        flutterEngine.getPlugins().add(new LifecycleEvents());
        flutterEngine.getPlugins().add(new Permissions());
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
