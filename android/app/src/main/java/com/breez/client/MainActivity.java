package com.breez.client;

import com.breez.client.plugins.*;
import com.breez.client.plugins.breez.BreezCredential;
import com.breez.client.plugins.breez.BreezDeepLinks;
import com.breez.client.plugins.breez.breezlib.Breez;
import com.breez.client.plugins.breez.*;
import com.breez.client.plugins.breez.ShareBreezLog;
import com.breez.client.plugins.breez.BreezShare;
import com.breez.client.plugins.breez.backup.BreezBackup;

import android.content.Context;
import android.net.Uri;
import android.os.Bundle;

import android.content.Intent;
import android.nfc.NfcAdapter;

import bindings.Bindings;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.os.PowerManager;
import android.provider.Settings;
import android.util.Log;

import java.text.Bidi;
import java.util.logging.Handler;
import java.util.logging.Level;
import java.util.logging.LogRecord;
import java.util.logging.Logger;

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
        BreezApplication.isRunning = true;
        isPos = this.getPackageName().equals("com.breez.client.pos");
        m_nfc = new NfcHandler(this);

        registerBreezPlugins();
        GeneratedPluginRegistrant.registerWith(this);
        addBreezLogHandler();
    }

    @Override
    protected void onDestroy() {
        Log.d(TAG, "Breez activity destroying...");
        super.onDestroy();
        System.exit(0);
    }

    void registerBreezPlugins() {
        new ImageCropper(this.registrarFor("com.breez.client.plugins.image_cropper"));
        new Breez(this.registrarFor("com.breez.client.plugins.breez_lib"));
        new BreezDeepLinks(this.registrarFor("com.breez.client.plugins.breez_deep_links"));
        BreezApplication.breezShare = new BreezShare(this.registrarFor("com.breez.client.plugins.breez_share"), this);
        new ShareBreezLog(this.registrarFor("com.breez.client.plugins.share_breez_log"), this);
        new BreezCredential(this.registrarFor("com.breez.client.plugins.breez_credential"), this);
        new LifecycleEvents(this.registrarFor("com.breez.client.plugins.lifecycle_events_notifications"));
        new LightningLinks(this.registrarFor("com.breez.client.plugins.lightning_links"));
        new BreezBackup(this.registrarFor("com.breez.client.plugins.backup"), this);
        new Permissions(this.registrarFor("com.breez.client.plugins.permissions"), this);
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

    private void addBreezLogHandler(){
        Logger rootLogger = Logger.getLogger("");
        rootLogger.addHandler(new Handler() {
            @Override
            public void publish(LogRecord logRecord) {
                if (logRecord.getLevel().intValue() <= Level.FINE.intValue()) {
                    Log.d(logRecord.getLoggerName(), logRecord.getMessage());
                    Bindings.log(logRecord.getMessage(), "FINE");
                    return;
                }
                if (logRecord.getLevel().intValue() <= Level.INFO.intValue()) {
                    Log.i(logRecord.getLoggerName(), logRecord.getMessage());
                    Bindings.log(logRecord.getMessage(), "INFO");
                    return;
                }
                if (logRecord.getLevel().intValue() <= Level.WARNING.intValue()) {
                    Log.w(logRecord.getLoggerName(), logRecord.getMessage(), logRecord.getThrown());
                    Bindings.log(logRecord.getMessage(), "WARNING");
                    return;
                }
                Log.e(logRecord.getLoggerName(), logRecord.getMessage(), logRecord.getThrown());
                Bindings.log(logRecord.getMessage(), "SEVERE");
                return;
            }

            @Override
            public void flush() {}

            @Override
            public void close() throws SecurityException {}
        });
    }
}
