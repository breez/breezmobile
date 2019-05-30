//
//  AppDelegate.swift
//  Runner
//
//  Created by Roei Erez on 4/10/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import UIKit
import Flutter
import Bindings

@UIApplicationMain
class AppDelegate : FlutterAppDelegate {
    
    var logger : BindingsLoggerProtocol = EmptyLogger();
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        GeneratedPluginRegistrant.register(with: self);
        registerBreezPlugins();
        //application.setMinimumBackgroundFetchInterval(3600);
        Notifier.scheduleSyncRequiredNotification();
        let workingDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        var error : NSError?;
        logger = BindingsGetLogger(workingDir, &error)!;
        logger.log("application has launched!", lvl: "INFO")
        return super.application(application, didFinishLaunchingWithOptions: launchOptions);
    }
    
    func registerBreezPlugins(){
        Breez.register(with: registrar(forPlugin: "com.breez.client.plugins.breez_lib"));
        LifecycleEvents.register(with: registrar(forPlugin: "com.breez.client.plugins.lifecycle_events_notifications"))
    }
    
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let jobName = userInfo["_job"] as? String?;
        if (jobName == "chainSync") {
            logger.log("chainSync notification received!", lvl: "INFO")
            ChainSync.run(app: application, completionHandler: {
                Notifier.scheduleSyncRequiredNotification();
                self.logger.log("Job completion handler was called!", lvl: "INFO");
                completionHandler(UIBackgroundFetchResult.newData);
            });
            return;
        }        
        super.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler);
        
    }
    
    override func applicationWillTerminate(_ application: UIApplication) {
        logger.log("application is about to terminate!", lvl: "INFO");
    }
    
    override func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Void {
        logger.log("background fetch started...", lvl: "INFO");
        completionHandler(UIBackgroundFetchResult.noData);
        
//        ChainSync.run(app: application, completionHandler: {
//            Notifier.scheduleSyncRequiredNotification();
//            completionHandler(UIBackgroundFetchResult.newData);
//        });
    }
}

class EmptyLogger : NSObject, BindingsLoggerProtocol {
    func log(_ msg: String?, lvl: String?) {
        print(msg);
    }
}
