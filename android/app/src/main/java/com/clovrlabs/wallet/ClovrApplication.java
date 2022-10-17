package com.clovrlabs.wallet;

import com.clovrlabs.wallet.plugins.breez.BreezShare;

import io.flutter.app.FlutterApplication;

public class ClovrApplication extends FlutterApplication {
    public static volatile boolean isBackground = false;
    public static volatile boolean isRunning = false;
    public static volatile BreezShare breezShare;
}
