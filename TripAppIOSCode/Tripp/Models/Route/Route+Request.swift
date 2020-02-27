//
//  Route+Request.swift
//  Tripp
//
//  Created by Monu on 01/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension Route {
    
    public func requestParameter() -> [String: Any]{
        var request: [String: Any] = [:]
        request["tripId"] = self.tripId
        request["name"] = self.name
        request["roadType"] = self.roadType
        request["drivingMode"] = self.drivingMode
        request["dateOfTrip"] = self.createdAt
        request["totalTime"] = self.totalTime
        request["distance"] = calculateDistance()
        request["tripMode"] = self.tripMode
        request["isAddedFromRoute"] = self.isAddedFromRoute
        request["fileUrl"] = (self.fileUrl == nil) ? "" : self.fileUrl
        if let value = self.categoryId.value {
            request["categoryId"] = value
        }
        if groupId != 0 {
            request["groupId"] = groupId
        }
        
        var waypoints: [[String: Any]] = []
        var indexNumber = 0
        for point in self.waypoints {
            var waypoint: [String: Any] = [:]
            waypoint["waypointId"] = point.waypointId
            waypoint["name"] = point.name
            waypoint["address"] = point.address
            waypoint["latitude"] = point.latitude
            waypoint["longitude"] = point.longitude
            waypoint["indexNumber"] = indexNumber
            waypoint["state"] = point.state
            waypoint["city"] = point.city
            waypoint["country"] = point.country != nil ? point.country : ""
            
            var mediaAssets:[[String:Any]] = []
            for media in point.waypointMedia {
                var mediaAsset:[String:Any] = [:]
                mediaAsset["mediaId"] = media.mediaId
                mediaAsset["caption"] = media.caption
                mediaAsset["sourcePath"] = media.sourcePath
                mediaAsset["type"] = media.type
                mediaAsset["state"] = media.state
                mediaAsset["city"] = media.city
                mediaAsset["address"] = media.address
                mediaAsset["latitude"] = media.latitude
                mediaAsset["longitude"] = media.longitude
                mediaAsset["country"] = media.country != nil ? media.country : ""
                mediaAssets.append(mediaAsset)
            }
            waypoint["media"] = mediaAssets
            
            indexNumber += 1
            waypoints.append(waypoint)
        }
        
        request["waypoints"] = waypoints
        
        return request
    }
    
    private func calculateDistance() -> String{
        if drivingMode == TripType.Sea.rawValue || drivingMode == TripType.Aerial.rawValue{
            return distanceFromWaypoints().toMiles()
        }
        else{
            return self.distance
        }
    }

    private func distanceFromWaypoints() -> Double{
        var firstPoint:CLLocation? = nil
        var totalDistanceInMeter = 0.0
        for point in waypoints {
            if firstPoint != nil {
                totalDistanceInMeter = totalDistanceInMeter + (firstPoint?.distance(from: CLLocation(latitude: point.location().latitude, longitude: point.location().longitude)))!
            }
            
            firstPoint = CLLocation(latitude: point.location().latitude, longitude: point.location().longitude)
        }
        
        return totalDistanceInMeter
    }
    
}
