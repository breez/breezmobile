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
    static let openElenPayWalletAction = UNNotificationAction(identifier: "openElenPayAction", title: "Open ElenPay Wallet", options: [.foreground])
    static let openElenPayCategory = UNNotificationCategory(identifier: "openElenPay", actions: [openElenPayWalletAction], intentIdentifiers: [], options: [])
    
    static func getNotificationCenter() -> UNUserNotificationCenter{
        if (notificationCenter == nil) {
            notificationCenter = UNUserNotificationCenter.current()
            notificationCenter!.setNotificationCategories([openElenPayCategory])
        }
        return notificationCenter!;
    }
    
    static func showClosedChannelNotification() {
        showNotification(withTitle: "Action Required", withBody: "ElenPay Wallet has identified a change in the state of one of your payment channels. It is highly recommended you open ElenPay Wallet in order to ensure access to your funds.", withActionCategoryId: openElenPayCategory.identifier, withIdentifier: "channelswatcher");
    }
    
    static func scheduleSyncRequiredNotification() {
        let center =  getNotificationCenter();
        center.removePendingNotificationRequests(withIdentifiers: ["syncwatcher"])
        showNotification(withTitle: "Action Required", withBody: "ElenPay Wallet has not been synchronized for more than 24 hours. It is highly recommended you openElenPay Walletin order to ensure access to your funds.", withActionCategoryId: openElenPayCategory.identifier, withIdentifier: "syncwatcher", withDelay: 3600 * 24 * 3);
    }
    
    static func showNotification(withTitle title: String, withBody body: String,
                                 withActionCategoryId catId: String,
                                 withIdentifier id : String,
                                 withDelay secondsDelay: TimeInterval = 1){
        //get the notification center
        let center =  getNotificationCenter();
        
        //create the content for the notification
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default;
        
        content.categoryIdentifier = catId
        
        //notification trigger can be based on time, calendar or location
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: secondsDelay, repeats: false)
        
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
