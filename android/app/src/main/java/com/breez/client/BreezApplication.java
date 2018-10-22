package com.breez.client;

import com.breez.client.plugins.breez.BreezShare;
import io.flutter.app.FlutterApplication;

public class BreezApplication extends FlutterApplication {

    private static boolean s_appRunning;

    public static boolean isBackground = false;
    public static BreezShare breezShare;

    public static synchronized boolean isAppRunning(){
        return s_appRunning;
    }

    public static synchronized void setAppRunning(){
        s_appRunning = true;
    }
}
