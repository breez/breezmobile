//
//  ChainSync.swift
//  Runner
//
//  Created by Roei Erez on 5/1/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import Bindings

class ChainSync : NSObject {
    static var queue : DispatchQueue = DispatchQueue(label: "technology.breez.client.chainsync");
    
    var bgTask : UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid;
    var syncJob : BindingsChannelsWatcherJobControllerProtocol?;
    var closedChannelsJob : BindingsJobControllerProtocol?;
    var app : UIApplication;
    
    static func run(app : UIApplication, completionHandler: @escaping () -> Void){
        let workingDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        var error : NSError?;
        let syncJob = BindingsNewSyncJob(workingDir, &error);
        if let _ = error {
            completionHandler();
            return;
        }
        
        let closedChannelsJob = BindingsNewClosedChannelsJob(workingDir, &error);
        if let _ = error {
            completionHandler();
            return;
        }
        
        queue.async{
            ChainSync(app: app, syncJob: syncJob!, closedChannelsJob: closedChannelsJob!).start();
            completionHandler();
        }
    }
    
    init(app : UIApplication, syncJob: BindingsChannelsWatcherJobControllerProtocol, closedChannelsJob : BindingsJobControllerProtocol) {
        self.syncJob = syncJob;
        self.closedChannelsJob = closedChannelsJob;
        self.app = app;
    }
    
    func start(){
//        self.bgTask = app.beginBackgroundTask(expirationHandler: {
//            self.stopTask();
//        });
        
        do {
            var boolRes : ObjCBool = false;
            let res = UnsafeMutablePointer<ObjCBool>(&boolRes);
            if (boolRes.boolValue) {
                // show notification.
                Notifier.showClosedChannelNotification();
            }            
            try syncJob!.run(res);
            try closedChannelsJob!.run();
        } catch {
            //log error
        }
        //stopTask();
        return;
    }
    
//    func stopTask(){
//        syncJob!.stop();
//        closedChannelsJob!.stop();
//        app.endBackgroundTask(bgTask);
//        bgTask = UIBackgroundTaskIdentifier.invalid;
//    }
}
