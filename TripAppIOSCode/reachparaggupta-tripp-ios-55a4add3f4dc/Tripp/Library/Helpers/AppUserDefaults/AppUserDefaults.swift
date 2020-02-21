//
//  AppUserDefaults.swift
//  Tripp
//
//  Created by Bharat lal on 08/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation


class AppUserDefaults {
    
    class func set(value: Any, for key: UserDefaultsKeys) {
        UserDefaults.standard.set(value, forKey: key.description)
        UserDefaults.standard.synchronize()
    }
    
    class func value(for key: UserDefaultsKeys) -> Any? {
       return UserDefaults.standard.value(forKey: key.description)
    }
    
}

enum UserDefaultsKeys: CustomStringConvertible {
    
    case routeTips
    case tripTips
    case tripWaypoitTip
    case livetrackingOn
    case routeDetailCount
    case walkthrough

    var description: String {
        switch self {
        case .routeTips:
            return "routes tips shown"
        case .tripTips:
            return "add trip tips shown"
        case . tripWaypoitTip:
           return "trip waypoint tips shown"
        case . livetrackingOn:
            return "live tracking On"
        case .routeDetailCount:
            return "routeDetailCount"
        case .walkthrough:
            return "app walkthrough shown"
            
        }
    }
}
