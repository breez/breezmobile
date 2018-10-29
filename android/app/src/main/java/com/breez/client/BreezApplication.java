package com.breez.client;

import com.breez.client.plugins.breez.BreezShare;
import io.flutter.app.FlutterApplication;

public class BreezApplication extends FlutterApplication {
    public static volatile boolean isBackground = false;
    public static volatile BreezShare breezShare;
    public static volatile boolean isRunning = false;
}
