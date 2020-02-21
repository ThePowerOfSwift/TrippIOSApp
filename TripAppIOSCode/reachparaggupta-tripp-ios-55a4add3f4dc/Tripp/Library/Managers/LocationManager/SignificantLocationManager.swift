//
//  SignificantLocationManager.swift
//  Tripp
//
//  Created by Monu Rathor on 05/09/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import CoreLocation

class SignificantLocationManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = SignificantLocationManager()
    var significantLocationManager: CLLocationManager?
    
    override init() {
        significantLocationManager = CLLocationManager()
        significantLocationManager?.allowsBackgroundLocationUpdates = true
        significantLocationManager?.pausesLocationUpdatesAutomatically = false
        significantLocationManager?.requestAlwaysAuthorization()
    }
    
    // MARK:- Instance Methods
    func startSignificantLocationUpdate() {
        significantLocationManager?.delegate = self
        significantLocationManager?.startMonitoringSignificantLocationChanges()
    }
    
    func stopSignificantLocationUpdate() {
        significantLocationManager?.delegate = nil
        significantLocationManager?.stopMonitoringSignificantLocationChanges()
    }
    
    // MARK:- CLLocationManagerDelegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        LiveTrackingManager.sharedManager.writeData(location: locations.last!, mode: "Start Significant Location")
        if LocationManager.sharedManager.locationManager == nil {
            LiveTrackingManager.sharedManager.writeToFile("Initialize location manager")
            // Only if not in memory
            LocationManager.sharedManager.resumeContinueLocation()
        }
    }
    
}
