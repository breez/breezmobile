package com.breez.client;

import com.breez.client.plugins.*;
import com.breez.client.plugins.breez.BreezCredential;
import com.breez.client.plugins.breez.BreezDeepLinks;
import com.breez.client.plugins.breez.BreezLib;
import com.breez.client.plugins.breez.*;
import com.breez.client.plugins.breez.ShareBreezLog;
import com.breez.client.plugins.breez.BreezShare;

import android.os.Bundle;

import android.content.Intent;
import android.nfc.NfcAdapter;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.util.Log;

import static android.content.Intent.ACTION_VIEW;

public class MainActivity extends FlutterActivity {
    private static final String TAG = "Breez";
    public static final int NOTIFICATION_ID = 200;
    private static final String MAIN_CHANNEL = "com.breez.client/main";
    public boolean isPos = false;

    MethodChannel mainMethodChannel;
    NfcHandler m_nfc;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.d(TAG, "Breez activity created...");

        m_nfc = new NfcHandler(this);

        mainMethodChannel = new MethodChannel(getFlutterView(), MAIN_CHANNEL);
        mainMethodChannel.setMethodCallHandler(
                new MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, Result result) {
                        if (call.method.equals("setPos")) {
                            try {
                                isPos = call.argument("isPos");
                                result.success(true);
                            } catch (Exception e) {
                                result.success(false);
                            }
                        }
                    }
                }
        );

        registerBreezPlugins();

        GeneratedPluginRegistrant.registerWith(this);
    }

    void registerBreezPlugins() {
        new ImageCropper(this.registrarFor("com.breez.client.plugins.image_cropper"));
        new BreezLib(this.registrarFor("com.breez.client.plugins.breez_lib"));
        new BreezDeepLinks(this.registrarFor("com.breez.client.plugins.breez_deep_links"));
        BreezApplication.breezShare = new BreezShare(this.registrarFor("com.breez.client.plugins.breez_share"), this);
        new ShareBreezLog(this.registrarFor("com.breez.client.plugins.share_breez_log"), this);
        new BreezCredential(this.registrarFor("com.breez.client.plugins.breez_credential"), this);
        new LifecycleEvents(this.registrarFor("com.breez.client.plugins.lifecycle_events_notifications"));
        new LightningLinks(this.registrarFor("com.breez.client.plugins.lightning_links"));
    }

    public void onPause() {
        super.onPause();
        BreezApplication.isBackground = true;
        m_nfc.disableForegroundDispatch();
    }

    public void onResume() {
        super.onResume();
        BreezApplication.isBackground = false;
        m_nfc.enableForegroundDispatch();
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        Log.d(TAG, "Got an intent...");

        if (intent != null && (intent.getAction().equals(BreezApduService.ACTION_BOLT11_RECEIVED)
                || intent.getAction().equals(NfcAdapter.ACTION_TAG_DISCOVERED)
                || intent.getAction().equals(NfcAdapter.ACTION_NDEF_DISCOVERED))) {
            m_nfc.handleIntent(intent);
        }
    }
}
