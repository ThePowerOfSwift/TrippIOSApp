//
//  AppDelegate+Notification.swift
//  Tripp
//
//  Created by Bharat Lal on 03/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

enum NotificationTime: Double {
    case oneDay = 86400.0
    case oneMinute = 60.0
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Delegate method-- will be called
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    // schedule Notification
    func scheduleNotificationForprofileComplition() {
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: NotificationTime.oneDay.rawValue,
            repeats: false) // show notification after 24 hrs, only once
        
        let content = UNMutableNotificationContent()
        content.title = appTitle
        content.body = profileNotification
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: profileNotificationIdentifier, content: content, trigger: trigger)
        
        cancelAllLocalNotifications()
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                DLog(message: error as AnyObject)
            }
        }
    }
    
    // Remove all pending notifications
    func cancelAllLocalNotifications(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        AppSharedClass.shared.deviceToken = Validation.validDeviceToken(deviceToken)
        DLog(message: "Device Token: \(AppSharedClass.shared.deviceToken)" as AnyObject)
        self.perform(#selector(AppDelegate.updateDeviceToken), with: nil, afterDelay: 1.0)
    }
    
    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        DLog(message: error as AnyObject)
    }
    
    // register for notification
    func registerNotifications() {
        //-- Register for push notification
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [UNAuthorizationOptions.badge, UNAuthorizationOptions.alert, UNAuthorizationOptions.sound], completionHandler: { _, _ in
                // Success
            })
        } else {
            // Fallback on earlier versions
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                _, _ in
                // Parse errors and track state
            }
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let notification = response.notification.request.content.userInfo as? [String:AnyObject] {
           // LocationFileManager.writeNotificationToFile(notification)
            parseRemoteNotification(notification: notification)
            
        }
        completionHandler()
    }

    @objc func updateDeviceToken(){
        //-- Update device token on server
        APIDataSource.updateDeviceToken()
    }
    
     func parseRemoteNotification(notification:[String:AnyObject]) {
        if let aps = notification["aps"] as? [String: Any], let groupIds = aps["groupData"] as? [Int], groupIds.count > 0 {
            Global.showGroupTabWith(groupIds[0])
        }
    }

}

