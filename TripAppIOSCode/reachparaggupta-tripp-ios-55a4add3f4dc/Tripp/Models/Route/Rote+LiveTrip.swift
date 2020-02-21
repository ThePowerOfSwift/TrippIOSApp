//
//  Rote+LiveTrip.swift
//  Tripp
//
//  Created by Bharat Lal on 23/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import RealmSwift

extension Route{
    class func currentTrip() -> Route?{
        do{
            let realm = try Realm()
            let predicate = NSPredicate(format: "isCurrent = true")
            let object =  realm.objects(Route.self).filter(predicate).first
            return object
        }catch{
            DLog(message: "Realm error: Something went wrong" as AnyObject)
            return nil
        }
    }
    
    func addLiveTripWaypoint(){
        let firstWaypoint = Wayponit()
        let lastWaypoint = Wayponit()
        self.waypoints.append(firstWaypoint)
        self.waypoints.append(lastWaypoint)
        self.isCurrent = true
        self.role = UserRole.Biker.rawValue
        
        //-- Set current date
        let formatter = DateFormatter()
        formatter.dateFormat = AppDateFormat.UTCFormat
        self.createdAt = formatter.string(from: Date())
    }
    
    func saveTrip(){
        self.saveObject()
    }
}
