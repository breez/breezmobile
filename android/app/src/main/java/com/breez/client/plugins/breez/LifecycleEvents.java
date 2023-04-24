package com.breez.client.plugins.breez;

import android.util.Log;

import androidx.annotation.NonNull;
import androidx.lifecycle.DefaultLifecycleObserver;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.ProcessLifecycleOwner;

import com.breez.client.BreezApplication;

import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.StreamHandler;

public class LifecycleEvents implements StreamHandler, FlutterPlugin, ActivityAware, DefaultLifecycleObserver {

    public static final String EVENTS_STREAM_NAME = "com.breez.client/lifecycle_events_notifications";

    private EventChannel.EventSink m_eventsListener;
    private EventChannel m_eventChannel;
    private Executor _executor = Executors.newCachedThreadPool();
    private ActivityPluginBinding binding;
    private FlutterPluginBinding flutterPluginBinding;

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
        m_eventChannel = new EventChannel(messenger, EVENTS_STREAM_NAME);
        m_eventChannel.setStreamHandler(this);
        ProcessLifecycleOwner.get().getLifecycle().addObserver(this);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        this.onDetachedFromActivity();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(final ActivityPluginBinding binding) {
        this.onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        m_eventChannel.setStreamHandler(null);
        m_eventChannel = null;
        ProcessLifecycleOwner.get().getLifecycle().removeObserver(this);
    }

    @Override
    public void onListen(Object args, final EventChannel.EventSink events) {
        m_eventsListener = events;
    }

    @Override
    public void onCancel(Object args) {
        m_eventsListener = null;
    }

    @Override
    public void onResume(@NonNull LifecycleOwner owner) {
        Log.d("CalyxOS", "DefaultLifecycleObserver ON_RESUME");
        BreezApplication.isBackground = false;
        Log.d("Breez", "App Resumed - onResume called");
        if (m_eventsListener != null) {
            _executor.execute(() -> {
                binding.getActivity().runOnUiThread(() -> {
                    m_eventsListener.success("resume");
                });
            });
        }
    }

    @Override
    public void onStop(@NonNull LifecycleOwner owner) {
        Log.i("CalyxOS", "DefaultLifecycleObserver ON_STOP");
        BreezApplication.isBackground = true;
        Log.d("Breez", "App Stopped - onStop called");
        if (m_eventsListener != null) {
            _executor.execute(() -> {
                binding.getActivity().runOnUiThread(() -> {
                    m_eventsListener.success("pause");
                });
            });
        }
    }
}
