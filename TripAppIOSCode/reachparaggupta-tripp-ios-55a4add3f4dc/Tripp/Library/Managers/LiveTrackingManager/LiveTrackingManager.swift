//
//  LiveTrackingManager.swift
//  Tripp
//
//  Created by Bharat Lal on 22/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import  RealmSwift
import CoreLocation
import GoogleMaps

class LiveTrackingManager {
    
    var locations = [LiveTripLocation]()
    var startLocation: LiveTripLocation?
    var currentLocation: LiveTripLocation?
    var isStarted = false
    var distance = 0.0
    var trip: Route?
    var path = GMSMutablePath()
    static var sharedManager = LiveTrackingManager()
    //MARK: Helpers
    
    func initializeInEditModeFrom(trip: Route){
        self.trip = trip
        if let latitude = trip.waypoints.first?.latitude, let longitude = trip.waypoints.first?.longitude {
            self.startLocation = LiveTripLocation(value: ["lat":latitude, "lon":longitude, "encodedPath": ""])
        }
        
        if let latitude = trip.waypoints.last?.latitude, let longitude = trip.waypoints.last?.longitude {
            self.currentLocation = LiveTripLocation(value: ["lat":latitude, "lon":longitude, "encodedPath": ""])
        }
    }
    
    func startTracking(_ location:CLLocation, isTripStarted:Bool) {
        
        self.startLocation = LiveTripLocation(value: ["lat":"\(location.coordinate.latitude)", "lon":"\(location.coordinate.longitude)", "encodedPath": ""])
        self.currentLocation = self.startLocation
        //-- Need to hold temp start and current location.
        if isTripStarted {
            self.distance = 0.0
            self.isStarted = true
            AppUserDefaults.set(value: true, for: .livetrackingOn)
            saveEncodedPathFrom([self.startLocation!.location!])
            self.trip?.updateStartLocationAndTime(startLocation: self.startLocation!)
        }
    }
    
    func saveEncodedPathFrom(_ locations: [CLLocationCoordinate2D]) {
        for location in locations{
            let coordinate = location
            path.add(coordinate)
        }
        let encodedPath = path.encodedPath()
        self.distance = path.length(of: .geodesic)
        if let location = locations.last {
            let newLocation = LiveTripLocation(value: ["lat":"\(location.latitude)", "lon":"\(location.longitude)"])
            self.trip?.updateEncodedPath(encodedPath, currentLocation: newLocation, distance: self.distance.toMiles())
        }
    }
    
    func assignTrackingManager(trip: Route){
        if let startLoc = trip.waypoints.first {
            self.startLocation = LiveTripLocation(value: ["lat":"\(startLoc.latitude)", "lon":"\(String(describing: startLoc.longitude))"])
        }
        
        self.currentLocation = trip.currentLocation
        self.distance = Double(trip.distance) ?? 0.0
        if let encodedPath = trip.encodedPath {
            trip.updatePolyline(encodedPath)
            if let oldPath = GMSPath(fromEncodedPath: encodedPath) {
                self.path = GMSMutablePath(path: oldPath)
            }
        }
    }
    
    func saveLocation(_ location:CLLocation, isForce:Bool){
        //appendNewDistance(location)
        saveEncodedPathFrom([(self.currentLocation?.location)!, location.coordinate])
        self.currentLocation = LiveTripLocation(value: ["lat":"\(location.coordinate.latitude)", "lon":"\(location.coordinate.longitude)"])
        self.locations.append(self.currentLocation!)
    }
    
    private func appendNewDistance(_ toLocation: CLLocation){
        self.distance = self.distance + toLocation.distance(from: CLLocation(latitude: (self.currentLocation?.location?.latitude)!, longitude: (self.currentLocation?.location?.longitude)!))
    }
    
    //MARK: Finish Tracking
    func finishTracking(handler:@escaping (_ fileName:String?) -> ()){
        if let fileDetails = trip?.writeToFile() {
            DLog(message: "file written at path: \(fileDetails.path)" as AnyObject)
            if !Connection.isInternetConnected(true){
                OfflineRoute.offlineRouteFrom(trip: trip!)
                handler(nil)
            }else{
                self.uploadFile(fileName: fileDetails.fileName, path: fileDetails.path, handler: handler)
            }
        }
        else{
            handler(nil)
        }
    }
    func finishOfflineTripTracking(trip :OfflineRoute, handler:@escaping (_ fileName:String?) -> ()){
        if let fileDetails = trip.writeToFile() {
            DLog(message: "file written at path: \(fileDetails.path)" as AnyObject)
            
            var offlineDict1 = trip.requestParameter()
            offlineDict1["fileUrl"] = fileDetails.fileName
            AppSharedClass.shared.params.append(offlineDict1)
            
            self.uploadFile(fileName: fileDetails.fileName, path: fileDetails.path, handler: handler)
            
        }
        else{
            handler(nil)
        }
    }

    
    
    func exit(){
        self.isStarted = false
        self.distance = 0.0
       // self.cleanLiveTrackingDB()
        AppUserDefaults.set(value: false, for: .livetrackingOn)
        SignificantLocationManager.sharedInstance.stopSignificantLocationUpdate()
    }
    
    private func uploadFile(fileName:String, path:URL, handler:@escaping (_ fileName:String?) -> ()){            
        AWSImageManager.sharedManger.uploadFileOnS3(atPath: path, name: FileType.liveTrip.rawValue + fileName, contentType: "text/txt", handler: { (isUploaded) in
            if isUploaded {
                handler(fileName)
            }
            else{
                handler(nil)
            }
        })
    }
    
    func cleanLiveTrackingDB(){
        
        Realm.truncateTable(Route.self)
        Realm.truncateTable(LiveTripLocation.self)
        distance = 0.0
        trip = nil
        isStarted = false
        startLocation = nil
        currentLocation = nil
        locations.removeAll()
        path = GMSMutablePath()
    }
    
    //MARK: Logger file
    func writeData(location: CLLocation, mode:String, fileName: String = #file, functionName: String = #function) {
        let formattedText = "Date: \(Date()) Lat: \(location.coordinate.latitude)  Lon: \(location.coordinate.longitude) HAccuracy: \(location.horizontalAccuracy) VAccuracy: \(location.verticalAccuracy) \n\n"
        self.writeToFile(formattedText)
    }
    
    func writeToFile(_ strData: String, fileName: String = #file, functionName: String = #function) {
        //#if DEBUG
        let formattedText = "File: \(fileName)  Method: \(functionName) \(strData)\n\n"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileName = "Logger.txt"
            let path = dir.appendingPathComponent(fileName)
            //-- Write all objects into file
            do {
                let fileText = try String(contentsOf: path)
                try (formattedText + fileText).write(to: path, atomically: true, encoding: .utf8)
            } catch {
                try! formattedText.write(to: path, atomically: true, encoding: .utf8)
            }
        }
        //#endif
    }
}
