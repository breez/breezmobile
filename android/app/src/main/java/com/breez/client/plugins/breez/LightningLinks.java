package com.breez.client.plugins.breez;

import android.content.Intent;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.PluginRegistry;

import static android.content.Intent.ACTION_VIEW;

public class LightningLinks implements EventChannel.StreamHandler {

    public static final String STREAM_NAME = "com.breez.client/lightning_links_stream";

    private EventChannel.EventSink m_eventsListener;
    private String m_startLink;

    public LightningLinks(PluginRegistry.Registrar registrar) {
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
        if (m_startLink != null) {
            m_eventsListener.success(m_startLink);
            m_startLink = null;
        }
    }

    @Override
    public void onCancel(Object args) {
        m_eventsListener = null;
    }

    public boolean checkLinkOnIntent(Intent intent) {
        if (intent != null
                && intent.getAction().equals(ACTION_VIEW)
                && intent.getData() != null
                && intent.getScheme().toLowerCase().contains("lightning")) {
            String link = intent.getDataString();
            if (m_eventsListener != null) {
                m_eventsListener.success(link);
            } else {
                m_startLink = link;
            }
            return true;
        }
        return false;
    }
}