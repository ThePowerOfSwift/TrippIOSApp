//
//  LocationFileManager.swift
//  Tripp
//
//  Created by Monu on 23/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import RealmSwift

class LocationFileManager: Object {
    
    var locations = List<LiveTripLocation>()
    
    private func writeToFile() -> (fileName:String, path:URL)? {
        let dictionary = self.convertLocationsIntoDictionary()
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileName = "\(AppUser.currentUser().userId)-" + AWSImageManager.sharedManger.newFileName("LiveTrip", fileExtension: ".txt")
            let path = dir.appendingPathComponent(FileType.liveTrip.rawValue + fileName)
            //-- Write all objects into file
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
                let decoded = String(data: jsonData, encoding: .utf8)
                try decoded?.write(to: path, atomically: true, encoding: .utf8)
                return (fileName: fileName, path: path)
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    private func convertLocationsIntoDictionary() -> NSDictionary {
        return self.toDictionary()
    }
    
    //MARK: Helpers
    class func writeAllLocationToFile() -> (fileName:String, path:URL)? {
        let locationFile = LocationFileManager()
        locationFile.locations = LiveTripLocation.allLocations()!
        return locationFile.writeToFile()
    }
    
    class func createLiveTripFolder(){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dataPath = documentsDirectory.appendingPathComponent(FileType.liveTrip.rawValue)
        do {
            try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("Error creating directory: \(error.localizedDescription)")
        }
    }
    
    class func writeNotificationToFile(_ data: [String: Any]) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileName = "\(AppUser.currentUser().userId)-" + AWSImageManager.sharedManger.newFileName("Notification", fileExtension: ".txt")
            let path = dir.appendingPathComponent(FileType.liveTrip.rawValue + fileName)
            //-- Write all objects into file
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                let decoded = String(data: jsonData, encoding: .utf8)
                try decoded?.write(to: path, atomically: true, encoding: .utf8)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
