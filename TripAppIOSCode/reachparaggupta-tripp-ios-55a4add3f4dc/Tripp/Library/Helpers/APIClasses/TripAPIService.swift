//
//  TripAPIService.swift
//  Tripp
//
//  Created by Monu on 16/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import Alamofire

public enum TripAPIService {
    
    public static let apiVersion = "v1"
    
    case addAsset(caption: String, sourcePath: String, type: Int, waypointId:Int, tripId:Int)
    case deleteAsset(mediaId: Int)
    case deleteWaypoint(waypointId: Int, tripId: Int)
    case deleteTrip(tripId:Int)
    
    var path: String {
        switch self { //please do not use default case
            
        case .addAsset:
            return "user/add-media"
            
        case .deleteAsset:
            return "user/delete-media"
            
        case .deleteWaypoint:
            return "user/delete-waypoints"
            
        case .deleteTrip:
            return "user/delete-route"
            
        }
    }
    
    var parameters: [String: Any] {
        switch self { //please do not use default case
        case let .addAsset(caption, sourcePath, type, waypointId, tripId):
            return ["media":[["caption":caption, "sourcePath":sourcePath, "type":type]], "waypointId":waypointId, "tripId":tripId]
            
        case let .deleteAsset(mediaId):
            return ["mediaId":mediaId]
            
        case let .deleteWaypoint(waypointId, tripId):
            return ["waypointId":waypointId, "tripId":tripId]
            
        case let .deleteTrip(tripId):
            return ["ids":tripId]
        }
    }
    
    var method: HTTPMethod {
        switch self { //please do not use default case
        case .addAsset, .deleteAsset, .deleteWaypoint, .deleteTrip:
            return .post
            
        }
    }
    
}
