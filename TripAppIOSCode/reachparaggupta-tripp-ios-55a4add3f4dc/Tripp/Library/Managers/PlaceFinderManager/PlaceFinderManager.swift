//
//  PlaceFinderManager.swift
//  Tripp
//
//  Created by Monu on 07/09/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import GoogleMaps

typealias PlaceFinderHandler = (_ places:[NearByPlace]?, _ error: NSError?) -> ()

class PlaceFinderManager {
    
    var handler: PlaceFinderHandler?
    var route: Route!
    var place: String = ""
    
    var radius: Double = 10000.0
    
    
    lazy var placeFinderQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Place Finder Queue"
        return queue
    }()
    
    
    /**
     * @method fetchingPlaces
     * @discussion start fetching routes
     */
    func fetchingPlaces(onRoute: Route, place:String, handler: PlaceFinderHandler?){
        if !Connection.isInternetConnected() {
            return
        }
        
        self.handler = handler
        self.place = place
        self.route = onRoute
        
        let wayPoints = waypointsOnPath()
        addPlaceFinderOperations(wayPoints)
    }
    
    fileprivate func addPlaceFinderOperations(_ coordinates:[CLLocationCoordinate2D]){
        for coordinate in coordinates {
            let operation = PlaceFinderOperation(place: place, radius: radius, coordinate: coordinate, handler: { (places, error) in
                if let handler = self.handler {
                    handler(places, error)
                }
            })
            placeFinderQueue.addOperation(operation)
        }
    }
    
    fileprivate func waypointsOnPath() -> [CLLocationCoordinate2D] {
        var wayPoints = [CLLocationCoordinate2D]()
        guard let polyline = route.polylineString as String? else {
            return wayPoints
        }
        if let path = GMSPath(fromEncodedPath: polyline), path.count() > 2 {
            wayPoints.append(path.coordinate(at: 0))
            wayPoints.append(path.coordinate(at: path.count() - 1))
            
            if path.length(of: .geodesic) > 20000 &&  path.length(of: .geodesic) < 100000 {
                wayPoints.append(contentsOf: middleWaypointsAtPath(path))
            }
            else {
                wayPoints.append(contentsOf: middleEightWayPointsAtPath(path))
            }
        }
        return wayPoints
    }
    
    fileprivate func middleWaypointsAtPath(_ path: GMSPath) -> [CLLocationCoordinate2D]{
        let distance = path.length(of: .geodesic)
        var waypoints = [CLLocationCoordinate2D]()
        
        // Middle waypoints
        if let centerWaypoint = waypointAtDistance(distance/2, path: path) {
            waypoints.append(centerWaypoint)
        }
        
        if distance > 50000 {
            // First one third waypoints
            if let centerWaypoint = waypointAtDistance(distance/4, path: path) {
                waypoints.append(centerWaypoint)
            }
            
            // Last one third waypoints
            if let centerWaypoint = waypointAtDistance((distance/4 + distance/2), path: path) {
                waypoints.append(centerWaypoint)
            }
        }
        
        return waypoints
    }
    
    
    
    //puneet code for 8 points between start and end
    
    fileprivate func middleEightWayPointsAtPath(_ path: GMSPath) -> [CLLocationCoordinate2D] {
        let distance = path.length(of: .geodesic)
        var waypoints = [CLLocationCoordinate2D]()
        
        // Middle waypoints
        if let centerWaypoint = waypointAtDistance(distance/2, path: path) {
            waypoints.append(centerWaypoint)
        }
        
       // if distance > 50000 {
            
            if let centerWaypoint = waypointAtDistance(distance/8, path: path) {
                waypoints.append(centerWaypoint)
            }
            
            if let centerWaypoint = waypointAtDistance(distance/4, path: path) {
                waypoints.append(centerWaypoint)
            }
            
            if let centerWaypoint = waypointAtDistance((distance/4 + distance/8), path: path) {
                waypoints.append(centerWaypoint)
            }
            
            if let centerWaypoint = waypointAtDistance((distance/2 + distance/8), path: path) {
                waypoints.append(centerWaypoint)
            }
            
            if let centerWaypoint = waypointAtDistance((distance/4 + distance/2), path: path) {
                waypoints.append(centerWaypoint)
            }
            
            if let centerWaypoint = waypointAtDistance((distance/4 + distance/2 + distance/8), path: path) {
                waypoints.append(centerWaypoint)
            }
       // }
        
        return waypoints
    }
    
    
    
    fileprivate func waypointAtDistance(_ distance: Double, path: GMSPath) -> CLLocationCoordinate2D? {
        var previousCoordinate: CLLocationCoordinate2D?
        var totalDistance: Double = 0.0
        for index in 1..<path.count() {
            guard let coordinate = previousCoordinate else {
                previousCoordinate = path.coordinate(at: index)
                continue
            }
            
            totalDistance = totalDistance + coordinateDistance(from: coordinate, to: path.coordinate(at: index))
            if totalDistance > distance {
                return coordinate
            }
            previousCoordinate = path.coordinate(at: index)
        }
        return nil
    }
    
    func coordinateDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
    
}
