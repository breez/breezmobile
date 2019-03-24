package com.breez.client.plugins.breez;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;

import com.breez.client.LogProvider;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class ShareBreezLog implements MethodChannel.MethodCallHandler {
    public static final String SHARE_BREEZ_LOG_CHANNEL_NAME = "com.breez.client/share_breez_log";
    private final Activity activity;

    public ShareBreezLog(PluginRegistry.Registrar registrar, Activity activity) {
        this.activity = activity;

        MethodChannel methodChannel = new MethodChannel(registrar.messenger(), SHARE_BREEZ_LOG_CHANNEL_NAME);
        methodChannel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("shareFile")) {
            try {
                String sourcePath = call.argument("path").toString();
                File sourceFile = new File(sourcePath);
                Object targetFileName = call.argument("targetFileName");
                File shareFile = new File(activity.getFilesDir().getPath() + "/" + (targetFileName == null ? sourceFile.getName() : targetFileName.toString()));
                copy(sourceFile, shareFile);
                Uri shareUri = LogProvider.getUriForFile(activity, activity.getApplicationContext().getPackageName() + ".log", shareFile);
                Intent intentShareFile = new Intent(Intent.ACTION_SEND);
                intentShareFile.putExtra(Intent.EXTRA_STREAM, shareUri);
                intentShareFile.setType("text/plain");
                activity.startActivity(Intent.createChooser(intentShareFile, "Share File"));
                result.success(true);
            } catch (Exception e) {
                result.success(false);
            }
        }
    }

    private static void copy(File src, File dst) throws IOException {
        try (InputStream in = new FileInputStream(src)) {
            try (OutputStream out = new FileOutputStream(dst)) {
                byte[] buf = new byte[1024];
                int len;
                while ((len = in.read(buf)) > 0) {
                    out.write(buf, 0, len);
                }
            }
        }
    }
}
