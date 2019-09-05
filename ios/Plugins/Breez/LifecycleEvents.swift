//
//  LifecycleEvents.swift
//  Runner
//
//  Created by Roei Erez on 4/11/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import Bindings

class LifecycleEvents : NSObject, FlutterPlugin, FlutterStreamHandler {
    var eventSink : FlutterEventSink?;
    var resumed = false;
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let BREEZ_STREAM_NAME = "com.breez.client/lifecycle_events_notifications";
        
        let instance = LifecycleEvents();        
        let eventChannel = FlutterEventChannel(name: BREEZ_STREAM_NAME, binaryMessenger: registrar.messenger());
        eventChannel.setStreamHandler(instance);
        
        registrar.addApplicationDelegate(instance);
        
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events;
        return nil;
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil;
        return nil;
    }
    
    func applicationDidBecomeActive(_ application : UIApplication) {        
        DispatchQueue.global().async {            
            if let sink = self.eventSink {
                if (self.resumed) {
                    sink("resume");
                }
            }
            self.resumed = true;
        }
        BindingsOnResume();
    }
    
    func applicationDidEnterBackground(_ application : UIApplication) {
        DispatchQueue.global().async {           
            if let sink = self.eventSink{
                sink("pause");
            }
        }
    }
    
}
