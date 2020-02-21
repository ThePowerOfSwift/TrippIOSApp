//
//  AppDelegate.swift
//  Tripp
//
//  Created by Monu on 13/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import RealmSwift
import FBSDKCoreKit
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        FacebookManager.initialize()
        self.backgroundModeLocation(launchOptions: launchOptions)
        ConfigurationManager.setAppConfiguration(launchOptions)
        fetchStateList()
        self.registerNotifications()
        
        InAppManager.sharedManger.initialize(self)
        
        if let userId = UserDefaults.standard.value(forKey: InAppManager.Keys.userId) as? Int, userId == AppUser.sharedInstance?.userId {
            InAppManager.sharedManger.verifyInAppReceipt()
        }
        
        OfflineRoute.sendOfflineToServer()
        
        // This should be last line always
        Fabric.with([Crashlytics.self])
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        LiveTrackingManager.sharedManager.writeToFile("--------------- applicationDidEnterBackground ------------------------\n")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        LiveTrackingManager.sharedManager.writeToFile("--------------- applicationDidBecomeActive ------------------------\n")
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        //-- Check location permission 
        if isLiveTrackingContinue() {
            LocationManager.sharedManager.checkLiveTrackingPermission(completion: { (status) in
                //-- Do nothing
            })
        }
        
        LocationManager.sharedManager.isLaunchFromBackground = false
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        LiveTrackingManager.sharedManager.writeToFile("--------------- applicationWillTerminate ------------------------\n")
    }

}

