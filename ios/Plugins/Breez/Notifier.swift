//
//  Notifier.swift
//  Runner
//
//  Created by Roei Erez on 5/1/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation

class Notifier : NSObject {
    
    static var notificationCenter : UNUserNotificationCenter?;
    static let notificationHandler = NotifierHandler();
    static let openBreezAction = UNNotificationAction(identifier: "openBreezAction", title: "Open Breez", options: [])
    static let openBreezCatagory = UNNotificationCategory(identifier: "openBreezCat", actions: [openBreezAction], intentIdentifiers: [], options: [.customDismissAction])
    
    static func getNotificationCenter() -> UNUserNotificationCenter{
        if (notificationCenter == nil) {
            notificationCenter = UNUserNotificationCenter.current()
            notificationCenter!.setNotificationCategories([openBreezCatagory])
            notificationCenter!.delegate = notificationHandler;
        }
        return notificationCenter!;
    }
    
    static func showClosedChannelNotification() {
        showNotification(withTitle: "Action Required", withBody: "Breez has identified a change in the state of one of your payment channels. It is highly recommended you open Breez in order to ensure access to your funds.", withActionCategoryId: openBreezCatagory.identifier, withIdentifier: "channelswatcher")
    }
    
    static func showNotification(withTitle title: String, withBody body: String, withActionCategoryId catId: String, withIdentifier id : String){
        //get the notification center
        let center =  getNotificationCenter();
        
        //create the content for the notification
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default;
        
        content.categoryIdentifier = catId
        
        //notification trigger can be based on time, calendar or location
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:1.0, repeats: false)
        
        //create request to display
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        //add request to notification center
        center.add(request) { (error) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
    }
}

class NotifierHandler : NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler();
    }
}
