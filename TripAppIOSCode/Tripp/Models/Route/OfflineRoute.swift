//
//  OfflineRoute.swift
//  Tripp
//
//  Created by puneet on 09/11/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation

class OfflineRoute: Route {
    
    static var staticOfflineTrips = Array<OfflineRoute>()
    
    class  func offlineRouteFrom(trip : Route){
        
        let offlineTrip = OfflineRoute()
        offlineTrip.tripId = trip.tripId
        offlineTrip.name = trip.name
        offlineTrip.role = trip.role
        offlineTrip.details = trip.details
        offlineTrip.roadType = trip.roadType
        offlineTrip.drivingMode = trip.drivingMode
        offlineTrip.tripMode = trip.tripMode
        offlineTrip.isMyWish = trip.isMyWish
        offlineTrip.isMyTrip = trip.isMyTrip
        offlineTrip.isPopular = trip.isPopular
        offlineTrip.routeImageCount = trip.routeImageCount
        offlineTrip.routeVideoCount = trip.routeVideoCount
        offlineTrip.rank = trip.rank
        offlineTrip.createdAt = trip.createdAt
        offlineTrip.state = trip.state
        offlineTrip.totalTime = trip.totalTime
        offlineTrip.distance = trip.distance
        offlineTrip.curviness = trip.curviness
        offlineTrip.dateOfTrip = trip.dateOfTrip
        offlineTrip.fileUrl = trip.fileUrl
        offlineTrip.encodedPath = trip.encodedPath
        offlineTrip.isAddedFromRoute = trip.isAddedFromRoute // 0 if user created trip else route id
        offlineTrip.currentLocation = trip.currentLocation
        offlineTrip.categoryId.value = trip.categoryId.value
        
        offlineTrip.isCurrent = trip.isCurrent
        offlineTrip.states = trip.states
        offlineTrip.waypoints = trip.waypoints
        offlineTrip.polylineString = trip.polylineString
        
        do{
            let realm = try Realm()
            AppUserDefaults.set(value: false, for: .livetrackingOn)
            try realm.write {
                realm.add(offlineTrip)
            }
        }catch{
            DLog(message: "Realm error: Something went wrong" as AnyObject)
        }
        
    }
    
    class func sendOfflineToServer(){
        var offlineTrips = Array<OfflineRoute>()
        do{
            let realm = try Realm()
            let offlineTrip123 = realm.objects(OfflineRoute.self)
            offlineTrips = Array(offlineTrip123)
            staticOfflineTrips = Array(offlineTrip123)
            
            DLog(message: "offlineTrips cout \(offlineTrips.count)" as AnyObject)
        }catch{
            DLog(message: "Realm error: Something went wrong" as AnyObject)
        }
        
        
        if offlineTrips.count > 0{
            
            AppSharedClass.shared.params.removeAll()
            let trackingManager = LiveTrackingManager.sharedManager
            
            for offlineTrip in offlineTrips{
                
                _ = offlineTrip.requestParameter()
                
                trackingManager.finishOfflineTripTracking(trip: offlineTrip, handler: { (fileName) in
                    if fileName != nil {
                        
                        DispatchQueue.main.async { () -> Void in
                            
                            AppSharedClass.shared.uploadedFileCount+=1
                            DLog(message: "uploadedFileCount is\(AppSharedClass.shared.uploadedFileCount)" as AnyObject)
                            
                            if AppSharedClass.shared.uploadedFileCount == offlineTrips.count{
                                OfflineRoute.saveMultipleTrips(paramsArray: AppSharedClass.shared.params)
                                print("kksksks\(AppSharedClass.shared.params)")
                            }
                        }
                    }
                    else{
                        AppLoader.hideLoader()
                        showTryAgainAlert()
                    }
                })
            }
            
        }
        
    }
    
    
    class func saveMultipleTrips(paramsArray: [[String : Any]]){
        DLog(message: "paramsArray is\(paramsArray)" as AnyObject)
        APIDataSource.addMultipleRoutes(service: .addMultipleRoutes(trips: paramsArray)){ (isSuccess, errorMessage) in
            if isSuccess!{
                //Utils.showAlertWithMessage("All files are deleted!!!")
                Realm.truncateTable(OfflineRoute.self)
            } else {
                //Utils.showAlertWithMessage("Failed to delete offline routes!!!")
                OfflineRoute.saveMultipleTrips(paramsArray: AppSharedClass.shared.params)
                
            }
        }
    }
    
    
    
    
    
}
