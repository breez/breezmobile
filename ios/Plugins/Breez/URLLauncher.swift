//
//  URLLauncher
//  Runner
//
//  Created by Roei Erez on 4/11/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation

class URLLauncher : NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let PLUGIN_CHANNEL_NAME = "com.breez.client/url_launcher";
        
        let instance = URLLauncher();
        let channel = FlutterMethodChannel(name: PLUGIN_CHANNEL_NAME, binaryMessenger: registrar.messenger());
        registrar.addMethodCallDelegate(instance, channel: channel);
        
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "launch") {
            if let args = call.arguments as? Dictionary<String,Any> {
                let urlStr : String = args["url"] as! String;
                if let url = URL(string: urlStr) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }                    
    }
}
