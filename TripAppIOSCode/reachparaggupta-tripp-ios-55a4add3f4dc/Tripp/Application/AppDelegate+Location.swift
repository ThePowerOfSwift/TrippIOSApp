//
//  AppDelegate+Location.swift
//  Tripp
//
//  Created by Monu on 30/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import GoogleMaps

extension AppDelegate {
    
    func backgroundModeLocation(launchOptions: [UIApplicationLaunchOptionsKey: Any]?){
        if launchOptions?[UIApplicationLaunchOptionsKey.location] != nil {
            LocationManager.sharedManager.isLaunchFromBackground = true
        }
        else{
            LocationManager.sharedManager.isLaunchFromBackground = false
        }
    }
    
    func isLiveTrackingContinue() -> Bool{
        if let isLiveTrcking = AppUserDefaults.value(for: .livetrackingOn) as? Bool, isLiveTrcking == true {
            return true
        }
        return false
    }
    
}
