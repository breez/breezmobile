//
//  BackgroundTask.swift
//  Runner
//
//  Created by Roei Erez on 6/4/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation

class BackgroundTask : NSObject, FlutterPlugin, FlutterStreamHandler {
    var eventSink : FlutterEventSink?;
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let PLUGIN_STREAM_NAME = "com.breez.client/background_task_notifications";
        let PLUGIN_CHANNEL_NAME = "com.breez.client/background_task";
        
        let instance = BackgroundTask();
        let eventChannel = FlutterEventChannel(name: PLUGIN_STREAM_NAME, binaryMessenger: registrar.messenger());
        eventChannel.setStreamHandler(instance);
        
        let channel = FlutterMethodChannel(name: PLUGIN_CHANNEL_NAME, binaryMessenger: registrar.messenger());
        registrar.addMethodCallDelegate(instance, channel: channel);
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "startBackgroundTask") {
            result(self.startBackgroundTask())
        }
        
        if (call.method == "stopBackgroundTask") {
            if let args = call.arguments as? Dictionary<String,Any> {
                let taskID : Int = args["taskID"] as! Int;
                self.stopBackgroundTask(identifier: UIBackgroundTaskIdentifier(rawValue: taskID));
            }
            result(true);
        }
    }
    
    func startBackgroundTask() -> UIBackgroundTaskIdentifier {
        var id = UIBackgroundTaskIdentifier.invalid;
        id = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            self.stopBackgroundTask(identifier: id);
        });
        Breez.logger.log("background task started", lvl: "INFO");
        return id
    }
    
    func stopBackgroundTask(identifier: UIBackgroundTaskIdentifier) {
        let remaining = UIApplication.shared.backgroundTimeRemaining;
        UIApplication.shared.endBackgroundTask(identifier);
        Breez.logger.log(String(format:"background task ended, time renaining=%f", remaining), lvl: "INFO");
        print("time ramaining %f", remaining);
        if let sink = self.eventSink {
            sink(identifier.rawValue);
        }
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events;
        return nil;
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil;
        return nil;
    }
}
