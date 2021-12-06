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
import flutter_downloader

class AppDelegate : FlutterAppDelegate {
    var savedOptions :  [UIApplication.LaunchOptionsKey : Any]?;
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        savedOptions = launchOptions;
        Breez.launchOptions = launchOptions;
        GeneratedPluginRegistrant.register(with: self);
        registerBreezPlugins();
        //application.setMinimumBackgroundFetchInterval(3600);
        Notifier.scheduleSyncRequiredNotification();
        SetCustomLogFilename(name: "logs/bitcoin/mainnet/lnd.log");
        FlutterDownloaderPlugin.setPluginRegistrantCallback({ registry in
            if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
                if let downloader = registry.registrar(forPlugin: "FlutterDownloaderPlugin") {
                    FlutterDownloaderPlugin.register(with: downloader);
                }
            }
        });        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions);
    }
    
    func SetCustomLogFilename(name: String) {
        let fileManager = FileManager.default;
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false);
            let fileURL = documentDirectory.appendingPathComponent(name);
            freopen(fileURL.path.cString(using: String.defaultCStringEncoding), "a+", stderr);
        } catch {
            print(error)
        }
    }
    
    func registerBreezPlugins(){
	if let b = registrar(forPlugin: "com.breez.client.plugins.breez_lib") {
	    Breez.register(with: b);
	}
	if let l = registrar(forPlugin: "com.breez.client.plugins.lifecycle_events_notifications") {
	    LifecycleEvents.register(with: l);
	}
	if let bt = registrar(forPlugin: "com.breez.client.background_task") {
	    BackgroundTask.register(with: bt)
	}
	if let t = registrar(forPlugin: "com.breez.client.plugins.tor") {
	    Tor.register(with: t)
	}
    }
    
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let jobName = userInfo["_job"] as? String?;
        if (jobName == "chainSync") {
            Breez.logger.log("chainSync notification received!", lvl: "INFO")            
            ChainSync.run(app: application, completionHandler: {
                Notifier.scheduleSyncRequiredNotification();
                Breez.logger.log("Job completion handler was called!", lvl: "INFO");
                if let options = self.savedOptions {
                    Breez.logger.log("launchOptions after job: " + options.description, lvl: "INFO")
                    print("launchOptions  after job: " + options.description);
                }
                completionHandler(UIBackgroundFetchResult.newData);
            });
            return;
        }        
        super.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler);
        
    }
    
    override func applicationWillTerminate(_ application: UIApplication) {
        Breez.logger.log("application is about to terminate!", lvl: "INFO");
    }
}
