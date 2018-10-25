package com.breez.client.plugins.breez;

import android.app.Activity;
import android.content.Intent;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

import static android.content.Intent.ACTION_VIEW;

public class LightningLinks implements EventChannel.StreamHandler, MethodChannel.MethodCallHandler {

    public static final String CHANNEL_NAME = "com.breez.client/lightning_links";
    public static final String STREAM_NAME = "com.breez.client/lightning_links_stream";

    private Activity m_activity;
    private EventChannel.EventSink m_eventsListener;

    public LightningLinks(PluginRegistry.Registrar registrar) {
        m_activity = registrar.activity();
        new MethodChannel(registrar.messenger(), CHANNEL_NAME).setMethodCallHandler(this);
        new EventChannel(registrar.messenger(), STREAM_NAME).setStreamHandler(this);
        registrar.addNewIntentListener(new PluginRegistry.NewIntentListener() {
            @Override
            public boolean onNewIntent(Intent intent) {
                return checkLinkOnIntent(intent);
            }
        });

        checkLinkOnIntent(registrar.activity().getIntent());
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
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        if (methodCall.method.equals("test")) {
        }
    }

    private boolean checkLinkOnIntent(Intent intent){
        android.net.Uri data = intent.getData();
        if (intent != null && intent.getAction().equals(ACTION_VIEW) && intent.getData() != null) {
            m_eventsListener.success(data);
            return true;
        }
        return false;
    }
}