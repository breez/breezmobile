package com.breez.client.plugins.breez;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.support.annotation.NonNull;
import android.util.Log;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.dynamiclinks.DynamicLink;
import com.google.firebase.dynamiclinks.FirebaseDynamicLinks;
import com.google.firebase.dynamiclinks.PendingDynamicLinkData;
import com.google.firebase.dynamiclinks.ShortDynamicLink;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

import bindings.Bindings;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class BreezDeepLinks implements EventChannel.StreamHandler, MethodChannel.MethodCallHandler {

    public static final String CHANNEL_NAME = "com.breez.client/breez_deep_links";
    public static final String STREAM_NAME = "com.breez.client/breez_deep_links_notifications";

    private Activity m_activity;
    private EventChannel.EventSink m_eventsListener;
    private String m_startLink;

    public BreezDeepLinks(PluginRegistry.Registrar registrar) {
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
        if (m_startLink != null) {
            m_eventsListener.success(m_startLink);
        }
    }

    @Override
    public void onCancel(Object args) {
        m_eventsListener = null;
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {        
        if (methodCall.method.equals("generateLink")) {            
            handleGenerateDeepLink(methodCall.argument("query").toString(), result);
        }
    }

    private void handleGenerateDeepLink(String query, final MethodChannel.Result result) {
        try {            
            Task<ShortDynamicLink> shortLinkTask = FirebaseDynamicLinks.getInstance().createDynamicLink()
                    .setLink(Uri.parse("https://breez.technology?" + query))
                    .setDynamicLinkDomain("breez.page.link")                    
                    .setAndroidParameters(new DynamicLink.AndroidParameters.Builder()
                            .setFallbackUrl(Uri.parse("https://play.google.com/apps/internaltest/4698115266871243990")) //hack for the beta
                            .build())
                    .buildShortDynamicLink()
                    .addOnCompleteListener(this.m_activity, new OnCompleteListener<ShortDynamicLink>() {
                        @Override
                        public void onComplete(@NonNull Task<ShortDynamicLink> task) {                            
                            if (!task.isSuccessful()) {
                                Log.e("Breez", "generate deep links failed", task.getException());
                                Log.e("Breez", task.getException().getMessage(), task.getException());
                                result.error("Error Genearating Link", task.getException().getMessage(), task.getException().getMessage());
                                return;
                            }

                            Uri shortLink = task.getResult().getShortLink();                            
                            result.success(shortLink.toString());
                        }
                    });
        }
        catch (Exception e) {            
            result.error("Error Genearating Link", e.getMessage(), e);
        }
    }

    private boolean checkLinkOnIntent(Intent intent){        
        android.net.Uri data = intent.getData();
        if (intent.getData() != null && data.getScheme().contains("http")) {
            FirebaseDynamicLinks.getInstance().getDynamicLink(intent)
                    .addOnCompleteListener(
                            m_activity,
                            new OnCompleteListener<PendingDynamicLinkData>() {
                                @Override
                                public void onComplete(@NonNull Task<PendingDynamicLinkData> task) {
                                    if (task.isSuccessful()) {
                                        PendingDynamicLinkData data = task.getResult();
                                        if (data != null) {
                                            if (m_eventsListener != null) {
                                                m_eventsListener.success(data.getLink().toString());
                                            } else {
                                                m_startLink = data.getLink().toString();
                                            }

                                        }
                                    }
                                }
                            });
            return true;
        }
        return false;
    }
}