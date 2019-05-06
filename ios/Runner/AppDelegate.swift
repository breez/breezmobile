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
        application.setMinimumBackgroundFetchInterval(3600);
        return super.application(application, didFinishLaunchingWithOptions: launchOptions);
    }
    
    func registerBreezPlugins(){
        Breez.register(with: registrar(forPlugin: "com.breez.client.plugins.breez_lib"));
        LifecycleEvents.register(with: registrar(forPlugin: "com.breez.client.plugins.lifecycle_events_notifications"))
    }
    
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let jobName = userInfo["_job"] as? String?;
        if (jobName == "chainSync") {
            ChainSync.run(app: application, completionHandler: {
                completionHandler(UIBackgroundFetchResult.newData);
            });
            return;
        }        
        super.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler);
        
    }
    
    override func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Void {
        print("background fetch started...");
        ChainSync.run(app: application, completionHandler: {
            completionHandler(UIBackgroundFetchResult.newData);
        });
    }
}
