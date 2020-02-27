//
//  LocationManager.swift
//  Tripp
//
//  Created by Bharat Lal on 05/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import  CoreLocation
import NRControls
import CoreMotion

typealias locationHandler = (_ location: CLLocation?, _ error: Error?)->()
typealias locationPermissionHandler = (_ status: CLAuthorizationStatus?) -> ()

class LocationManager: NSObject {
    
    static let sharedManager = LocationManager()
    var locationManager : CLLocationManager?
    var isPermissionGranted = false
    var handler: locationHandler?
    var permissionHandler: locationPermissionHandler?
    var isContinue = false
    var isFirstLocationFound = false
    var isLaunchFromBackground = false

    fileprivate let motion = CMMotionManager()
    
    var lastLocation: CLLocation? {
        get {
            guard let lat = UserDefaults.standard.value(forKey: "latitude") as? Double, lat > 0 else { return nil }
            guard let lon = UserDefaults.standard.value(forKey: "longitude") as? Double else { return nil }
            return CLLocation(latitude: lat, longitude: lon)
        }
        set {
            if newValue == nil {
                UserDefaults.standard.setValue(0, forKey: "latitude")
                UserDefaults.standard.setValue(0, forKey: "longitude")
            } else {
                UserDefaults.standard.setValue(newValue?.coordinate.latitude ?? 0, forKey: "latitude")
                UserDefaults.standard.setValue(newValue?.coordinate.longitude ?? 0, forKey: "longitude")
            }
        }
    }
    
    private override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.activityType = .automotiveNavigation
        locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.distanceFilter = 30
        motion.accelerometerUpdateInterval = 1.0 / 60.0
    }
    
    func setupLocationManager(){
        self.locationManager?.requestAlwaysAuthorization()
    }
    
    func resumeContinueLocation(){
        setupLocationManager()
        isContinue = true
        locationManager?.startUpdatingLocation()
    }
    
    func stopFetchingLocation(){
        self.locationManager?.stopUpdatingLocation()
        locationManager?.delegate = nil
    }
    
    func continueFetchLocation(complitionHandler:@escaping locationHandler){
        self.isContinue = true
        self.locationManager?.delegate = self
        handler = complitionHandler
        let status =  CLLocationManager.authorizationStatus()
        if status == .notDetermined || status != .authorizedAlways {
            locationManager?.requestAlwaysAuthorization()
        } else {
            fetchLocation(complitionHandler: complitionHandler)
        }
    }
    
    func currentLocation(complitionHandler:@escaping locationHandler){
        self.isContinue = false
        self.locationManager?.delegate = self
        handler = complitionHandler
        let status =  CLLocationManager.authorizationStatus()
        if status == .notDetermined {
             locationManager?.requestAlwaysAuthorization()
        }else{
            fetchLocation(complitionHandler: complitionHandler)
        }
    }
    
    func fetchLocation(complitionHandler:@escaping locationHandler){
        locationManager?.delegate = self
        handler = complitionHandler
        let status =  CLLocationManager.authorizationStatus()
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager?.startUpdatingLocation()
        } else {
            if let complitionHandler = handler{
                let error = Utils.generateError("locationError", code: -1301, message: locationAccessDenied)
                complitionHandler(nil, error)
                locationPermissionAlert(message: error.localizedDescription)
            }
        }
    }
    
    //MARK: Permission denied alert
    func locationPermissionAlert(message: String){
        NRControls.sharedInstance.openAlertViewFromViewController(UIApplication.topViewController()!, message: message, buttonsTitlesArray: [cancel, settings], completionHandler: { (alertController, index) in
            if index == 1 {
                // open settings
                Utils.openSettingsApp()
            }
        })
    }
    
    func checkLiveTrackingPermission(completion: locationPermissionHandler?){
        let status =  CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways:
            completion!(.authorizedAlways)
            
        case .denied, .authorizedWhenInUse:
            locationPermissionAlert(message: locationAccessDeniedAlways)
            completion!(status)
            
        case .notDetermined:
            permissionHandler = completion
            self.locationManager?.requestAlwaysAuthorization()
            
        case .restricted:
            locationPermissionAlert(message: locationAccessDeniedAlways)
            completion!(status)
            
        }
    }
}
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !self.isContinue {
            stopFetchingLocation()
            self.sendLocationToHandler(locations)
        }
        else if let newestLocation = locations.first, isValidLocation(location: newestLocation) {
            self.lastLocation = newestLocation
            self.sendLocationToHandler(locations)
            LiveTrackingManager.sharedManager.writeData(location: locations.first!, mode: "locationManager")
        }
    }
    
    func sendLocationToHandler(_ locations: [CLLocation]){
        let location = locations.first
        if self.isLaunchFromBackground {
            if let lastLatitude = LiveTrackingManager.sharedManager.currentLocation?.lat, lastLatitude == location?.coordinate.latitude.description {
                return
            }
            
            if let trip = Route.currentTrip() {
                LiveTrackingManager.sharedManager.assignTrackingManager(trip: trip)
                LiveTrackingManager.sharedManager.saveLocation(location!, isForce: true)
                LiveTrackingManager.sharedManager.writeData(location: location!, mode: "backgroundModeLocation")
            }
        } else if let complitionHandler = handler{
            complitionHandler(location, nil)
        }
    }
    
    func isValidLocation(location: CLLocation) -> Bool {
        if self.motion.isDeviceMoving() {
            guard let lastLocation = self.lastLocation else { return true }
            let distance = lastLocation.distance(from: location)
            if distance > 5, location.speed > 0 {
                return true
            }
        }
        return false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let complitionHandler = handler{
            complitionHandler(nil, error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if let handler = permissionHandler {
            handler(status)
            permissionHandler = nil
            return
        }
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager?.startUpdatingLocation()
        case .denied:
            if let complitionHandler = handler{
                let error = Utils.generateError("locationError", code: -1301, message: locationAccessDenied)
                complitionHandler(nil, error)
            }
        default:
            break
        }
    }
}

extension CMMotionManager {
    
    func isDeviceMoving() -> Bool {
        return true
        if self.isAccelerometerAvailable == true, let data = self.accelerometerData?.acceleration {
            print("Accelerometer: ", data)
            if data.x != 0 || data.y != 0 {
                return true
            }
        } else {
            print("Accelerometer not moving.")
        }
        return false
    }
    
}
