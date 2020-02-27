//
//  Devices.swift
//  Tripp
//
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

class Devices {

    let device = UIDevice.current
    static let deviceIdentifier = UIDevice.current.identifierForVendor!.uuidString
    static let deviceOSName = UIDevice.current.systemName
    static let deviceOSVersion = UIDevice.current.systemVersion

    class var isRunningSimulator: Bool {
        get {
            return TARGET_OS_SIMULATOR != 0 // Use this line in Xcode 7 or newer
        }
    }
    class func deviceName() -> String {
       
        return UIDevice.current.type.rawValue
    }
    
}
