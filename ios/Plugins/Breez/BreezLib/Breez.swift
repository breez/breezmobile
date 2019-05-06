//
//  Breez.swift
//  Runner
//
//  Created by Roei Erez on 4/10/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import Flutter
import Bindings
import GoogleSignIn


class Breez : NSObject, FlutterPlugin, BindingsAppServicesProtocol, FlutterStreamHandler {
    
    var eventSink : FlutterEventSink?;
    var googleAuth = GoogleAuthenticator();
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let BREEZ_CHANNEL_NAME = "com.breez.client/breez_lib";
        let BREEZ_STREAM_NAME = "com.breez.client/breez_lib_notifications";
        
        let instance = Breez();
        let channel = FlutterMethodChannel(name: BREEZ_CHANNEL_NAME, binaryMessenger: registrar.messenger());
        registrar.addMethodCallDelegate(instance, channel: channel);
        
        let eventChannel = FlutterEventChannel(name: BREEZ_STREAM_NAME, binaryMessenger: registrar.messenger());
        eventChannel.setStreamHandler(instance);
        
        registrar.addApplicationDelegate(instance);
        
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "init") {
            initBreez(call: call, result: result);
            return;
        }
       
        if (call.method == "log") {
            log(call: call, result: result);
        }
        
        if (call.method == "signIn") {
            signIn(call: call, result: result);
        }
        
        let executor = NativeMethods.getExecutor(forMethod: call.method);
        if executor != nil {
            print(call.method)
            executor?.execute(call: call, result: result);
        }
    }
    
    func initBreez(call: FlutterMethodCall, result: @escaping FlutterResult){
        if let args = call.arguments as? Dictionary<String,Any> {
            let tempDir : String = args["tempDir"] as! String;
            let workingDir : String = args["workingDir"] as! String;
            var err : NSError?
            if (!BindingsInit(tempDir, workingDir, self, &err)){
                result(true)
            } else {
                result(err);
            }
        }
        result(FlutterError(code: "Missing Argument", message: "Expecting a dictionary", details: nil));
    }
    
    func log(call: FlutterMethodCall, result: @escaping FlutterResult){
        if let args = call.arguments as? Dictionary<String,Any> {
            let msg : String = args["msg"] as! String;
            let lvl : String = args["lvl"] as! String;
            BindingsLog(msg, lvl);
            result(true);
        }
        result(FlutterError(code: "Missing Argument", message: "Expecting a dictionary", details: nil));
    }
    
    func signIn(call: FlutterMethodCall, result: @escaping FlutterResult){
        DispatchQueue.global().async {
            do {
                let _ = try self.googleAuth.getAccessToken(silentOnly: false)
                result(true);
            } catch {
                result(FlutterError(code: "AuthError", message: "Failed to signIn breez library", details: ""));
            }
        }
    }
    
    // FlutterStreamHandler protocol
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events;
        return nil;
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil;
        return nil;
    }
    
    // BindingsAppServicesProtocol protocol
    func backupProviderName() -> String! {
        return "gdrive"
    }
    
    func backupProviderSignIn() throws -> String {
        return try googleAuth.getAccessToken(silentOnly: true);
    }
    
    func notify(_ notificationEvent: Data!) {
        if let sink = eventSink {
            var data = Data(count:0);
            if let wrapped = notificationEvent {
                data = wrapped;
            }
            sink(FlutterStandardTypedData(bytes: data));
        }
    }
}


