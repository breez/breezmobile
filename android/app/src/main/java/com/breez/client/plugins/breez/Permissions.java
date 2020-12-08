package com.breez.client.plugins.breez;

import android.app.Activity;
import android.app.KeyguardManager;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.PowerManager;
import android.provider.Settings;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.lifecycle.ProcessLifecycleOwner;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class Permissions implements MethodChannel.MethodCallHandler, PluginRegistry.ActivityResultListener, FlutterPlugin, ActivityAware {
    public static final String BREEZ_PERMISSIONS_CHANNEL_NAME = "com.breez.client/permissions";
    public static final int BREEZ_PERMISSIONS_REQUEST_CODE = 9735;
    public static final int BREEZ_PERMISSIONS_SETTINGS_CODE = 9736;
    private static final String TAG = "BreezPermissions";
    private MethodChannel m_methodChannel;
    private MethodChannel.Result m_result;
    private MethodChannel.Result m_settingsRequestResult;

    private ActivityPluginBinding binding;
    private FlutterPlugin.FlutterPluginBinding flutterPluginBinding;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        this.flutterPluginBinding = null;
    }

    @Override
    public void onAttachedToActivity(final ActivityPluginBinding binding) {
        this.binding = binding;
        BinaryMessenger messenger = flutterPluginBinding.getBinaryMessenger();
        m_methodChannel = new MethodChannel(messenger, BREEZ_PERMISSIONS_CHANNEL_NAME);
        m_methodChannel.setMethodCallHandler(this);
        binding.addActivityResultListener(this);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        this.onDetachedFromActivity();
        binding.removeActivityResultListener(this);
    }

    @Override
    public void onReattachedToActivityForConfigChanges(final ActivityPluginBinding binding) {
        this.onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        m_methodChannel.setMethodCallHandler(null);
        m_methodChannel = null;
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        if (methodCall.method.equals("requestOptimizationWhitelist")) {
            requestOptimizationWhitelist(result);
        }
        if (methodCall.method.equals("requestOptimizationSettings")) {
            requestOptimizationSettings(result);
        }
        if (methodCall.method.equals("isInOptimizationWhitelist")) {
            isInOptimizationWhitelist(result);
        }
    }

    private void isInOptimizationWhitelist(MethodChannel.Result result) {
        result.success(isNotOptimized());
    }

    private void requestOptimizationWhitelist(MethodChannel.Result result){
        PowerManager pm = (PowerManager) binding.getActivity().getSystemService(Context.POWER_SERVICE);
        String packageName = binding.getActivity().getApplicationContext().getPackageName();
        if (!pm.isIgnoringBatteryOptimizations(packageName)) {
            m_result = result;
            Intent intent = new Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS);
            intent.setData(Uri.parse("package:" + packageName));
            binding.getActivity().startActivityForResult(intent, BREEZ_PERMISSIONS_REQUEST_CODE);
        }
    }

    private void requestOptimizationSettings(MethodChannel.Result result){
        String packageName = binding.getActivity().getApplicationContext().getPackageName();
        m_settingsRequestResult = result;
        Intent intent = new Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS);
        binding.getActivity().startActivityForResult(intent, BREEZ_PERMISSIONS_SETTINGS_CODE);
    }

    private boolean isNotOptimized(){
        PowerManager pm = (PowerManager) binding.getActivity().getSystemService(Context.POWER_SERVICE);
        String packageName = binding.getActivity().getApplicationContext().getPackageName();
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

        if (requestCode == BREEZ_PERMISSIONS_SETTINGS_CODE) {
            boolean notOptimized = isNotOptimized();
            Log.i(TAG, "Breez permissions activiety back with result notOptimized: " + notOptimized);
            m_settingsRequestResult.success(notOptimized);
            return true;
        }
        return false;
    }
}
