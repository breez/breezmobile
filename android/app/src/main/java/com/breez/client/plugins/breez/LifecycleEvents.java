package com.breez.client.plugins.breez;

import android.util.Log;

import androidx.annotation.NonNull;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleObserver;
import androidx.lifecycle.OnLifecycleEvent;
import androidx.lifecycle.ProcessLifecycleOwner;

import com.breez.client.BreezApplication;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

public class LifecycleEvents implements StreamHandler, FlutterPlugin, ActivityAware, LifecycleObserver {

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
    public void onListen(Object args, final EventChannel.EventSink events){
        m_eventsListener = events;
    }

    @Override
    public void onCancel(Object args) {
        m_eventsListener = null;
    }


    @OnLifecycleEvent(Lifecycle.Event.ON_RESUME)
    public void onResume() {
        BreezApplication.isBackground = false;
        Log.d("Breez", "App Resumed - OnPostResume called");
        if (m_eventsListener != null) {
            _executor.execute(() -> {
                binding.getActivity().runOnUiThread(() -> {
                    m_eventsListener.success("resume");
                });
            });
        }
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_STOP)
    public void onStop() {
        BreezApplication.isBackground = true;
        Log.d("Breez", "App Paused - onPause called");
        if (m_eventsListener != null) {
            _executor.execute(() -> {
                binding.getActivity().runOnUiThread(() -> {
                    m_eventsListener.success("pause");
                });
            });
        }
    }
}
