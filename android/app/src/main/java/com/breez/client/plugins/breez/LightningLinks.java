package com.breez.client.plugins.breez;

import android.app.Activity;
import android.content.Intent;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.PluginRegistry;

import static android.content.Intent.ACTION_VIEW;

public class LightningLinks implements EventChannel.StreamHandler {

    public static final String STREAM_NAME = "com.breez.client/lightning_links_stream";

    private EventChannel.EventSink m_eventsListener;

    public LightningLinks(PluginRegistry.Registrar registrar) {
        new EventChannel(registrar.messenger(), STREAM_NAME).setStreamHandler(this);
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

    public void checkLinkOnIntent(Intent intent){
        if (intent != null && intent.getAction().equals(ACTION_VIEW) && intent.getData() != null) {
            m_eventsListener.success(intent.getDataString().substring(10));
        }
    }
}