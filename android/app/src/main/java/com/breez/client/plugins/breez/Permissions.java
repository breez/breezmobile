package com.breez.client.plugins.breez;

import android.app.Activity;
import android.app.KeyguardManager;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.PowerManager;
import android.provider.Settings;
import android.util.Log;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class Permissions implements MethodChannel.MethodCallHandler, PluginRegistry.ActivityResultListener {
    public static final String BREEZ_PERMISSIONS_CHANNEL_NAME = "com.breez.client/permissions";
    public static final int BREEZ_PERMISSIONS_REQUEST_CODE = 9735;
    private static final String TAG = "BreezPermissions";
    private Activity m_activity;
    private MethodChannel m_methodChannel;
    private MethodChannel.Result m_result;

    public Permissions(PluginRegistry.Registrar registrar, Activity activity) {
        this.m_activity = activity;
        m_methodChannel = new MethodChannel(registrar.messenger(), BREEZ_PERMISSIONS_CHANNEL_NAME);
        m_methodChannel.setMethodCallHandler(this);
        registrar.addActivityResultListener(this);
    }
    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        if (methodCall.method.equals("requestOptimizationWhitelist")) {
            requestOptimizationWhitelist(result);
        }
        if (methodCall.method.equals("isInOptimizationWhitelist")) {
            isInOptimizationWhitelist(result);
        }
    }

    private void isInOptimizationWhitelist(MethodChannel.Result result) {
        result.success(isNotOptimized());
    }

    private void requestOptimizationWhitelist(MethodChannel.Result result){
        PowerManager pm = (PowerManager) m_activity.getSystemService(Context.POWER_SERVICE);
        String packageName = m_activity.getApplicationContext().getPackageName();
        if (!pm.isIgnoringBatteryOptimizations(packageName)) {
            m_result = result;
            Intent intent = new Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS);
            intent.setData(Uri.parse("package:" + packageName));
            m_activity.startActivityForResult(intent, BREEZ_PERMISSIONS_REQUEST_CODE);
        }
    }

    private boolean isNotOptimized(){
        PowerManager pm = (PowerManager) m_activity.getSystemService(Context.POWER_SERVICE);
        String packageName = m_activity.getApplicationContext().getPackageName();
        return pm.isIgnoringBatteryOptimizations(packageName);
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent intent) {
        if (requestCode == BREEZ_PERMISSIONS_REQUEST_CODE) {
            boolean notOptimized = isNotOptimized();
            Log.i(TAG, "Breez permissions activiety back with result notOptimized: " + notOptimized);
            m_result.success(notOptimized);
            return true;
        }
        return false;
    }
}
