package com.breez.client.plugins.breez;

import android.app.Activity;
import android.content.Intent;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import android.net.*;

public class URLLauncher implements MethodChannel.MethodCallHandler  {
    public static final String BREEZ_LAUNCHER_CHANNEL_NAME = "com.breez.client/url_launcher";
    private MethodChannel m_methodChannel;
    private final Activity m_activity;

    public URLLauncher(PluginRegistry.Registrar registrar, Activity activity) {
        this.m_activity = activity;
        m_methodChannel = new MethodChannel(registrar.messenger(), BREEZ_LAUNCHER_CHANNEL_NAME);
        m_methodChannel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("launch")) {
            m_activity.startActivity(new Intent(Intent.ACTION_VIEW)
                    .setData(Uri.parse(call.argument("url"))));
        }
    }
}
