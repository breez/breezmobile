package com.breez.client.plugins.breez;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.app.PendingIntent;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;
import androidx.lifecycle.ProcessLifecycleOwner;

import com.breez.client.BreezShareReceiver;
import com.breez.client.plugins.breez.breezlib.GoogleAuthenticator;

import java.lang.reflect.Method;

import bindings.Bindings;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

import static android.app.Activity.RESULT_CANCELED;

public class BreezShare implements MethodChannel.MethodCallHandler, PluginRegistry.ActivityResultListener, FlutterPlugin, ActivityAware {
    public static final int BREEZ_SHARE_REQUEST = 42;
    public static final String BREEZ_SHARE_CHANNEL_NAME = "com.breez.client/share_breez";
    private MethodChannel m_methodChannel;
    private MethodChannel.Result m_result;
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
        m_methodChannel = new MethodChannel(messenger, BREEZ_SHARE_CHANNEL_NAME);
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
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == BreezShare.BREEZ_SHARE_REQUEST && m_result != null) {
            m_result.success(resultCode != RESULT_CANCELED);
            m_result = null;
            return true;
        }
        return false;
    }

    public void onChooserResult() {
        if (m_result != null) {
            m_result.success(true);
            m_result = null;
        }
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("share")) {
            try {
                m_result = result;
                Intent shareIntent = new Intent();
                shareIntent.setAction(Intent.ACTION_SEND);
                shareIntent.putExtra(Intent.EXTRA_TEXT, (String) call.argument("text"));
                shareIntent.setType("text/plain");

                Intent receiver = new Intent(binding.getActivity(), BreezShareReceiver.class);
                PendingIntent pendingIntent = PendingIntent.getBroadcast(binding.getActivity(), 0, receiver, PendingIntent.FLAG_UPDATE_CURRENT);

                Intent chooserIntent = Intent.createChooser(shareIntent,
                        call.argument("title") == null ? null : (String) call.argument("title"),
                        pendingIntent.getIntentSender());
                binding.getActivity().startActivityForResult(chooserIntent, BREEZ_SHARE_REQUEST);
            }
            catch(Exception e) {
                result.success(false);
            }
        }
    }
}
