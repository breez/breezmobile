package com.breez.client.plugins.breez;

import android.app.Activity;
import android.os.AsyncTask;
import android.util.Log;

import io.flutter.plugin.common.ActivityLifecycleListener;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import bindings.*;
import java.lang.reflect.*;
import java.util.*;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

public class LifecycleEvents implements StreamHandler, ActivityLifecycleListener {

    public static final String EVENTS_STREAM_NAME = "com.breez.client/lifecycle_events_notifications";

    private EventChannel.EventSink m_eventsListener;
    private Executor _executor = Executors.newCachedThreadPool();
    private Activity m_activity;

    public LifecycleEvents(PluginRegistry.Registrar registrar) {
        m_activity = registrar.activity();
        new EventChannel(registrar.messenger(), EVENTS_STREAM_NAME).setStreamHandler(this);
        registrar.view().addActivityLifecycleListener(this);
    }

    @Override
    public void onListen(Object args, final EventChannel.EventSink events){
        m_eventsListener = events;
    }

    @Override
    public void onCancel(Object args) {
        m_eventsListener = null;
    }


    @Override
    public void onPostResume() {
        Log.d("Breez", "App Resumed - OnPostResume called");
        if (m_eventsListener != null) {
            _executor.execute(() -> {
                m_activity.runOnUiThread(() -> {
                    m_eventsListener.success("resume");
                });
            });
        }
    }

    public void onPause() {
        Log.d("Breez", "App Paused - onPause called");
        if (m_eventsListener != null) {
            _executor.execute(() -> {
                m_activity.runOnUiThread(() -> {
                    m_eventsListener.success("pause");
                });
            });
        }
    }
}

