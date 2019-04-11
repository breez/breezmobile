//
//  AppDelegate.swift
//  Runner
//
//  Created by Roei Erez on 4/10/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import UIKit
import Flutter

@UIApplicationMain
class AppDelegate : FlutterAppDelegate {
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        GeneratedPluginRegistrant.register(with: self);
        registerBreezPlugins();
        return super.application(application, didFinishLaunchingWithOptions: launchOptions);
    }
    
    func registerBreezPlugins(){
        Breez.register(with: registrar(forPlugin: "com.breez.client.plugins.breez_lib"));
    }
}
