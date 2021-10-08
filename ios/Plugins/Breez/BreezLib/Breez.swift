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

protocol BackupAuthenticatorProtocol {
    func backupProviderSignIn(silent: Bool, in err: NSErrorPointer) -> String;
    func signOut();
}

class EmptyLogger : NSObject, BindingsLoggerProtocol {
    func log(_ msg: String?, lvl: String?) {
        print(msg!);
    }
}

class Breez : NSObject, FlutterPlugin, BindingsAppServicesProtocol, FlutterStreamHandler {
    static var logger : BindingsLoggerProtocol = EmptyLogger();
    static var launchOptions :  [UIApplication.LaunchOptionsKey : Any]?;
    
    var eventSink : FlutterEventSink?;
    var backupAuthenticators : Dictionary<String, BackupAuthenticatorProtocol> = ["gdrive":GoogleAuthenticator(), "icloud": iCloudAuthenticator()];
    var backupProvider : String?;
    
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
        return GIDSignIn.sharedInstance().handle(url as URL?)
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "launchOptions") {
            launchOptions(call: call, result: result);
            return;
        }
        
        if (call.method == "init") {
            initBreez(call: call, result: result);
            return;
        }
        
        if (call.method == "setBackupProvider") {
            setBackupProvider(call: call, result: result);
            return;
        }
       
        if (call.method == "log") {
            log(call: call, result: result);
        }
        
        if (call.method == "signIn") {
            signIn(call: call, result: result);
        }
        
        if (call.method == "signOut") {
            signOut(call: call, result: result);
        }
        
        if (call.method == "restoreBackup") {
            restoreBackup(call: call, result: result)
        }
        
        if (call.method == "setBackupEncryptionKey") {
            setBackupEncryptionKey(call: call, result: result)
        }
        
        let executor = NativeMethods.getExecutor(forMethod: call.method);
        if executor != nil {
            print(call.method)
            executor?.execute(call: call, result: result);
        }
    }
    
    func launchOptions(call: FlutterMethodCall, result: @escaping FlutterResult){
        var res: [String: Any?] = [:]
        if let options = Breez.launchOptions {
            if let notificationOption = options[UIApplication.LaunchOptionsKey.remoteNotification] as? String {
                if notificationOption.contains("_job") {
                    res["jobLaunched"] = true;
                } else {
                    res["jobLaunched"] = false;
                }
            }
        }
        result(res)
    }
    
    func initBreez(call: FlutterMethodCall, result: @escaping FlutterResult){
        if let args = call.arguments as? Dictionary<String,Any> {
            let tempDir : String = args["tempDir"] as! String;
            let workingDir : String = args["workingDir"] as! String;
            var err : NSError?
            BindingsRegisterNativeBackupProvider("icloud", iCloudBackupProvider());
            if (BindingsInit(tempDir, workingDir, self, &err)){
                var error : NSError?;
                Breez.logger = BindingsGetLogger(workingDir, &error)!;
                result(true)
            } else {
                result(FlutterError(code: "", message: err?.description, details: nil));
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
    
    func setBackupProvider(call: FlutterMethodCall, result: @escaping FlutterResult){
        if let args = call.arguments as? Dictionary<String,Any> {
            let providerName : String = args["provider"] as! String;
            var auth = "";
            if let authData : String = args["authData"] as? String {
                auth = authData
            }
            var errorPtr: NSError?;
            BindingsSetBackupProvider(providerName, auth, &errorPtr)
            if let err = errorPtr {
                result(FlutterError(code: "AuthError", message: err.localizedDescription, details: ""));
                return;
            }
            self.backupProvider = providerName;
            result(true);
        }
        result(FlutterError(code: "Missing Argument", message: "Expecting a dictionary", details: nil));
    }
    
    func signIn(call: FlutterMethodCall, result: @escaping FlutterResult){
        DispatchQueue.global().async {
            var errorPtr: NSError?;
            guard let provider = self.backupProvider else {
                result(FlutterError(code: "AuthError", message: "Failed to signIn breez library", details: ""));
                return;
            }
            var _ = self.backupAuthenticators[provider]?.backupProviderSignIn(silent: false, in: &errorPtr);
            if let _ = errorPtr {
                result(FlutterError(code: "AuthError", message: "Failed to sign in breez library", details: ""));
                return;
            }
            
            result(true);
        }
    }
    
    func signOut(call: FlutterMethodCall, result: @escaping FlutterResult){
        DispatchQueue.global().async {
            guard let provider = self.backupProvider else {
                result(FlutterError(code: "AuthError", message: "Failed to sign out breez library", details: ""));
                return;
            }
            self.backupAuthenticators[provider]?.signOut();
            result(true);
        }
    }
    
    func restoreBackup(call: FlutterMethodCall, result: @escaping FlutterResult){
        DispatchQueue.global().async {
            do {
                if let args = call.arguments as? Dictionary<String,Any> {
                    let nodeID : String = args["nodeID"] as! String;
                    
                    var keyData : Data? = nil;
                    if let encryptionKey : FlutterStandardTypedData = args["encryptionKey"] as? FlutterStandardTypedData {
                        keyData = encryptionKey.data;
                    }
                    var error : NSError?;
                    if (BindingsRestoreBackup(nodeID, keyData, &error)) {
                        result(true);
                    } else {
                        result(FlutterError(code: error?.localizedDescription ?? "", message: error?.localizedDescription, details: nil));
                    }
                }
                result(FlutterError(code: "Missing Argument", message: "Expecting a dictionary", details: nil));
            }
        }
    }
    
    func setBackupEncryptionKey(call: FlutterMethodCall, result: @escaping FlutterResult){
        DispatchQueue.global().async {
            do {
                if let args = call.arguments as? Dictionary<String,Any> {
                    let encryptionType : String = args["encryptionType"] as! String;
                    var keyData : Data? = nil;
                    if let encryptionKey : FlutterStandardTypedData = args["encryptionKey"] as? FlutterStandardTypedData {
                        keyData = encryptionKey.data;
                    }
                    
                    var error : NSError?;
                    if (BindingsSetBackupEncryptionKey(keyData, encryptionType, &error)) {
                        result(true);
                    } else {
                        result(FlutterError(code: "", message: error?.localizedDescription, details: nil));
                    }
                    return;
                }
                result(FlutterError(code: "Missing Argument", message: "Expecting a dictionary", details: nil));
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
    func backupProviderName() -> String {
        guard let provider = self.backupProvider else {
            return "";
        }
        return provider;
    }
   
    func backupProviderSign(in err: NSErrorPointer) -> String {
        guard let provider = self.backupProvider else {
            err?.pointee = NSError(domain: "AuthError", code: 0, userInfo: nil);
            return "";
        }
        return self.backupAuthenticators[provider]!.backupProviderSignIn(silent: true, in: err);
    }

    func notify(_ notificationEvent: Data?) {
        if let sink = eventSink {
            var data = Data(count:0);
            if let wrapped = notificationEvent {
                data = wrapped;
            }
            sink(FlutterStandardTypedData(bytes: data));
        }
    }
}


