//
//  LiveTripLocation+Helper.swift
//  Tripp
//
//  Created by Bharat Lal on 22/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

extension LiveTripLocation {
    
    var location: CLLocationCoordinate2D? {
        get {
            guard let latitude = Double(self.lat), let longitude = Double(self.lon) else {
                return nil
            }
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    class func allLocations() -> List<LiveTripLocation>? {
        do{
            let realm = try Realm()
            let objects =  realm.objects(LiveTripLocation.self)
            
            return objects.reduce(List<LiveTripLocation>()) { (list, element) -> List<LiveTripLocation> in
                list.append(element)
                return list
            }
        }catch{
            DLog(message: "Realm error: Something went wrong" as AnyObject)
        }
        return nil
    }
    
}

