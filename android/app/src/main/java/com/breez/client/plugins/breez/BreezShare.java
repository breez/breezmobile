package com.breez.client.plugins.breez;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.app.PendingIntent;

import com.breez.client.BreezShareReceiver;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

import static android.app.Activity.RESULT_CANCELED;

public class BreezShare implements MethodChannel.MethodCallHandler, PluginRegistry.ActivityResultListener {
    public static final int BREEZ_SHARE_REQUEST = 42;
    public static final String BREEZ_SHARE_CHANNEL_NAME = "com.breez.client/share_breez";
    private final Activity m_activity;
    private MethodChannel m_methodChannel;
    private MethodChannel.Result m_result;

    public BreezShare(PluginRegistry.Registrar registrar, Activity activity) {
        this.m_activity = activity;
        m_methodChannel = new MethodChannel(registrar.messenger(), BREEZ_SHARE_CHANNEL_NAME);
        m_methodChannel.setMethodCallHandler(this);

        registrar.addActivityResultListener(this);
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

                Intent receiver = new Intent(m_activity, BreezShareReceiver.class);
                PendingIntent pendingIntent = PendingIntent.getBroadcast(m_activity, 0, receiver, PendingIntent.FLAG_UPDATE_CURRENT);

                Intent chooserIntent = Intent.createChooser(shareIntent,
                        call.argument("title") == null ? null : (String) call.argument("title"),
                        pendingIntent.getIntentSender());
                m_activity.startActivityForResult(chooserIntent, BREEZ_SHARE_REQUEST);
            }
            catch(Exception e) {
                result.success(false);
            }
        }
    }
}
