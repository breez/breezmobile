package com.breez.client.plugins.breez;

import android.app.Activity;
import android.app.KeyguardManager;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.PowerManager;
import android.provider.Settings;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class Permissions implements MethodChannel.MethodCallHandler {
    public static final String BREEZ_PERMISSIONS_CHANNEL_NAME = "com.breez.client/permissions";
    private Activity m_activity;
    private MethodChannel m_methodChannel;

    public Permissions(PluginRegistry.Registrar registrar, Activity activity) {
        this.m_activity = activity;
        m_methodChannel = new MethodChannel(registrar.messenger(), BREEZ_PERMISSIONS_CHANNEL_NAME);
        m_methodChannel.setMethodCallHandler(this);
    }
    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        if (methodCall.method.equals("requestOptimizationWhitelist")) {
            requestOptimizationWhitelist();
        }
    }

    private void requestOptimizationWhitelist(){
        PowerManager pm = (PowerManager) m_activity.getSystemService(Context.POWER_SERVICE);
        String packageName = m_activity.getApplicationContext().getPackageName();
        if (!pm.isIgnoringBatteryOptimizations(packageName)) {
            Intent intent = new Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS);
            intent.setData(Uri.parse("package:" + packageName));
            m_activity.getApplicationContext().startActivity(intent);
        }
    }
}
