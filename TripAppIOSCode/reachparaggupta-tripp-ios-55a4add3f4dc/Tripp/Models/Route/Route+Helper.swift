//
//  Route+Helper.swift
//  Tripp
//
//  Created by Monu on 12/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import RealmSwift

extension Route {
    
    func waypointsCoordinates() -> [String]{
        if waypoints.count < 3 {
            return []
        }
        var points: [String] = []
        for index in 1 ..< (waypoints.count - 1) {
            points.append(waypoints[index].latitude + "," + waypoints[index].longitude)
            
        }
        return points
    }
    
    var imageURL: String{
        get{
            return self.firstPhotoURL()
        }
    }
    var distanceInMiles: String{
        get{
            return distance + " miles"
        }
    }
    var sortDistanceInMiles: String{
        get{
            let dis = Double(distance) ?? 0.0
            return "\(dis.rounded(toPlaces: 2)) miles"
        }
    }
    
    var tripDate: String {
        get{
            if let date = self.dateOfTrip{
                return date.convertFormatOfDate(AppDateFormat.sortDate, originFormat: AppDateFormat.UTCShort)
            }
            return self.createdAt.convertFormatOfDate(AppDateFormat.sortDate)
        }
    }
    func categoryName(handler: @escaping (_ name: String) -> ()){
        guard let id = categoryId.value else {
            handler(noCategory)
            return
        }
        CategoryManager.sharedManager.categoryById(id, handler: { category in
            if let cat = category{
                handler(cat.name)
            }else{
                handler(noCategory)
            }
        })
    }
    func firstPhotoURL() -> String{
        for waypoint in self.waypoints{
            for media in waypoint.waypointMedia{
                if media.type == MediaType.photo.rawValue{
                    return media.sourcePath
                }
            }
        }
        return ""
    }
    func routeColor() -> UIColor{
        
        // route is completed by user
        if isMyTrip{
            return UIColor.completedRouteColor()
        }
        // route is popular
       /* if isPopular{
            return UIColor.popularRouteColor()
        }*/
        
        // color code based on road type
        return roadColor()
    }
    private func roadColor() -> UIColor{
        var color = UIColor()
        switch self.roadType {
        case RoadType.easy.rawValue:
            color = UIColor.routeEasyColor()
        case RoadType.intermediate.rawValue:
            color = UIColor.routeIntermidiateColor()
        case RoadType.difficult.rawValue:
            color = UIColor.routeDificultColor()
        default:
            color = UIColor.routeProColor()
        }
        return color
    }
    func routeMapIcons() -> (startPoint: String, endPoint: String){
        var ponits = (startPoint: "", endPoint: "")
        switch self.roadType {
        case RoadType.easy.rawValue:
            ponits = (startPoint: marker_green_star, endPoint: marker_green_circule)
        case RoadType.intermediate.rawValue:
            ponits = (startPoint: marker_blue_star, endPoint: marker_blue_circule)
        case RoadType.difficult.rawValue:
            ponits = (startPoint: marker_red_star, endPoint: marker_red_circule)
        default:
            ponits = (startPoint: marker_yellow_star, endPoint: marker_yellow_circule)
        }
        return ponits
    }
    func wishMarkerIcon() -> String {
        var marker = ""
        switch self.roadType {
        case RoadType.easy.rawValue:
            marker = starMarkerYellow
        case RoadType.intermediate.rawValue:
            marker = starMarkerOrrange
        case RoadType.difficult.rawValue:
            marker = starMarkerRed
        default:
            marker = starMarkerPro
        }
        return marker
    }
    func startMarker() -> GMSMarker{
        let startLat = Double(self.waypoints.first!.latitude)
        let startLon = Double(self.waypoints.first!.longitude)
        
        let startPosition = CLLocationCoordinate2D(latitude: startLat!, longitude: startLon!)
        
        let startMArker = RouteMarker(position: startPosition) //GMSMarker(position: startPosition)
        startMArker.route = self
        startMArker.icon = UIImage(named: wishMarkerIcon())
        
        return startMArker
    }
    func endMarker() -> GMSMarker{
        
        let endLat = Double(self.waypoints.last!.latitude)
        let endLon = Double(self.waypoints.last!.longitude)
        let endPosition = CLLocationCoordinate2D(latitude: endLat!, longitude: endLon!)
        
        let endMArker = RouteMarker(position: endPosition) //GMSMarker(position: endPosition)
        endMArker.route = self
        
        endMArker.icon = UIImage(named: wishMarkerIcon())
        
        return endMArker
    }
    
    func roadLevelString() -> String{
        switch self.roadType {
        case RoadType.easy.rawValue:
            return "Easy"
            
        case RoadType.intermediate.rawValue:
            return "Intermediate"
            
        case RoadType.difficult.rawValue:
            return "Difficult"
            
        case RoadType.pro.rawValue:
            return "Advanced"
            
        default: return ""
        }
    }
    func roadLevelIcon() -> String{
        switch self.roadType {
        case RoadType.easy.rawValue:
            return icLavelEasy
            
        case RoadType.intermediate.rawValue:
            return icLavelIntermediate
            
        case RoadType.difficult.rawValue:
            return icLavelDefficult
            
        case RoadType.pro.rawValue:
            return icLavelPro
            
        default: return ""
        }
    }
    func savedPoints() -> String{
        return "\(self.waypoints.count) locations"
    }
    
    func roadTypeString() -> String{
        if isMyTrip {
            return "Completed"
        }
        else if isPopular {
            return "Popular"
        }
        else{
            return roadLevelString()
        }
    }
    
    func totalDuration() -> String{
        guard let _ = self.totalTime?.isEmpty else {
            return " N/A"
        }
        
        return self.totalTime!
    }
    
    func radiusForPlaceArea() -> CGFloat{
        let startLat = Double(self.waypoints.first!.latitude)
        let startLon = Double(self.waypoints.first!.longitude)
        let startPosition = CLLocation(latitude: startLat!, longitude: startLon!)
        
        let endLat = Double(self.waypoints.last!.latitude)
        let endLon = Double(self.waypoints.last!.longitude)
        let endPosition = CLLocation(latitude: endLat!, longitude: endLon!)
        
        let distanceInMeters = startPosition.distance(from: endPosition)
        
        return CGFloat(distanceInMeters) / CGFloat(self.waypoints.count * 10)
    }
    
    //-- Get state name
    var stateName: String? {
        if self.states.count > 0 {
            return self.states.first?.name
        }
        return "No State"
    }
    
    //Add to my wish list
    func addToMyWish(handler: @escaping (_ message: String?, _ error: String?) -> ()){
        APIDataSource.addRouteToWishList(service: .addToMyWish(tripId: self.tripId)) { (message, error) in
            if error == nil{
                self.isMyWish = true
                AnalyticsManager.addToWishList(route: self)
            }
            handler(message, error)
        }
    }
    //Add to my trip
    func addToMyTrip(categoryId : String, handler: @escaping (_ message: String?, _ error: String?) -> ()){
        
        APIDataSource.addRouteToWishList(service: .addToMyTrip(tripId: self.tripId, categoryId: categoryId)) { (message, error) in
            if error == nil{
                self.isMyTrip = true
                AnalyticsManager.addToMyTrip(route: self)
            }
            handler(message, error)
        }
    }
    //remove from wish list
    func removeFromWishList(handler: @escaping (_ message: String?, _ error: String?) -> ()){
        APIDataSource.addRouteToWishList(service: .removeFromWishList(tripId: self.tripId)) { (message, error) in
            if error == nil{
                self.isMyWish = false
            }
            handler(message, error)
        }
    }
    
    // Start and End coordinate
    func startCoordinate() -> CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: Double((self.waypoints.first?.latitude)!)!, longitude: Double((self.waypoints.first?.longitude)!)!)
    }
    
    // Start and End coordinate
    func endCoordinate() -> CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: Double((self.waypoints.last?.latitude)!)!, longitude: Double((self.waypoints.last?.longitude)!)!)
    }
    
    func updateWaypoint(list: List<Wayponit>){
        self.waypoints = list
    }
    
    func curvinessValue() -> String{
        if let _ = self.curviness {
            return self.curviness!
        }
        else{
            return "N/A"
        }
    }
    //MARK: Update object in DB
    func updateLiveTripWaypointAndDistance(startLocation: LiveTripLocation, lastLocation: LiveTripLocation){
        
        do{
            let realm = try Realm()
            try realm.write({
                self.waypoints.first?.latitude =  startLocation.lat
                self.waypoints.first?.longitude = startLocation.lon
                self.waypoints.last?.latitude =   lastLocation.lat
                self.waypoints.last?.longitude =    lastLocation.lon
                self.distance = LiveTrackingManager.sharedManager.path.length(of: .geodesic).toMiles()
            })
        }catch{
            // error
        }
    }
    
    func updateStartLocationAndTime(startLocation: LiveTripLocation){
        do{
            let realm = try Realm()
            try realm.write({
                self.waypoints.first?.latitude =  startLocation.lat
                self.waypoints.first?.longitude = startLocation.lon
                self.createdAt = Date().currentUTCTimeZoneString
            })
        }catch{
            // error
        }
    }
    
    func findTotalDistanceOfPath(path: GMSPath) -> Double {
        let numberOfCoords = path.count()
        var totalDistance = 0.0
        if numberOfCoords > 1 {
            totalDistance = LiveTrackingManager.sharedManager.path.length(of: .geodesic)
            totalDistance = totalDistance/1609.344
        } else {
            var index = 0 as UInt
            while index  < numberOfCoords{
                let currentCoord = path.coordinate(at: index)
                let nextCoord = path.coordinate(at: index + 1)
                let newDistance = GMSGeometryDistance(currentCoord, nextCoord)
                totalDistance = totalDistance + newDistance
                index = index + 1
            }
        }
        return totalDistance
        
    }
    func updateTripStats(fileUrl: String, groupId: Int? = nil){
        do{
            let realm = try Realm()
            try realm.write({
                if let groupId = groupId {
                    self.groupId = groupId
                }
                self.fileUrl = fileUrl
                self.distance = LiveTrackingManager.sharedManager.path.length(of: .geodesic).toMiles()
                self.totalTime = calculateTotalTime()
            })
        }catch{
            // error
        }
    }
    func updateCategory(_ id: Int?){
        do{
            let realm = try Realm()
            try realm.write({
                self.categoryId.value = id
            })
        }catch{
            // error
        }
    }
    func updateEncodedPath(_ encodedPath: String, currentLocation: LiveTripLocation, distance: String){
        do{
            let realm = try Realm()
            try realm.write({
                self.encodedPath = encodedPath
                self.distance = distance
                if !currentLocation.lat.isEmpty {
                    self.currentLocation = currentLocation
                }
            })
        }catch{
            // error
        }
    }
    
    func updatePolyline(_ encodedPath: String){
        do{
            let realm = try Realm()
            try realm.write({
                self.polylineString = encodedPath as NSString
            })
        }catch{
            // error
        }
    }
    
    func calculateTotalTime() -> String{
        let startTime = createdAt.toDate()
        let seconds = (startTime?.timeIntervalSinceNow ?? 0) * -1//hours(from: startTime ?? Date()).description
        let time = secondsToHoursMinutesSeconds(seconds: Int(seconds))
        //let minutes = currentTime.minutes(from: startTime ?? Date()).description
        let minutes = (time.1 <= 9) ? "0" + time.1.description : time.1.description
        return  time.0.description + "." + minutes
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    //MARK: write to file 
     func writeToFile() -> (fileName:String, path:URL)? {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileName = "\(AppUser.currentUser().userId)-" + AWSImageManager.sharedManger.newFileName("LiveTrip", fileExtension: ".txt")
            let path = dir.appendingPathComponent(FileType.liveTrip.rawValue + fileName)
            //-- Write all objects into file
            do {
                let decoded = self.encodedPath
                try decoded?.write(to: path, atomically: true, encoding: .utf8)
                return (fileName: fileName, path: path)
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    //MARK: Copy of a object
    override func copy() -> Any {
        let copy = Route()
        copy.copyObject(fromRoute: self)
        return copy
    }
    
    func copyObject(fromRoute: Route) {
        self.tripId = fromRoute.tripId
        self.name = fromRoute.name
        self.role = fromRoute.role
        self.details = fromRoute.details
        self.roadType = fromRoute.roadType
        self.drivingMode = fromRoute.drivingMode
        self.isAddedFromRoute = fromRoute.isAddedFromRoute
        //self.isCompleted = fromRoute.isCompleted
        self.isMyTrip = fromRoute.isMyTrip
        self.isMyWish = fromRoute.isMyWish
        self.isPopular = fromRoute.isPopular
        self.routeImageCount = fromRoute.routeImageCount
        self.routeVideoCount = fromRoute.routeVideoCount
        self.rank = fromRoute.rank
        self.createdAt = fromRoute.createdAt
        self.state = fromRoute.state
        self.totalTime = fromRoute.totalTime
        self.distance = fromRoute.distance
        self.curviness = fromRoute.curviness
        self.dateOfTrip = fromRoute.dateOfTrip
        self.tripMode = fromRoute.tripMode
        self.fileUrl = fromRoute.fileUrl
        self.categoryId.value = fromRoute.categoryId.value
        self.states.removeAll()
        for state in fromRoute.states {
            self.states.append(state.copy() as! TripState)
        }
        
        self.waypoints.removeAll()
        for waypoint in fromRoute.waypoints {
            self.waypoints.append(waypoint.copy() as! Wayponit)
        }
        
        self.polylineString = fromRoute.polylineString
    }
    class func routeFromWish(_ wish: WishList) -> Route{
        let wishRoute = wish.trip!
        let route = Route()
        route.tripId = wish.tripId
        route.name = wishRoute.name
        route.role = UserRole.Admin.rawValue
        route.roadType = wishRoute.roadType
        route.drivingMode = wishRoute.drivingMode
        route.isMyTrip = wishRoute.isMyTrip
        route.isMyWish = wishRoute.isMyWish
        route.distance = wishRoute.distance
        route.polylineString = nil
        route.waypoints = wishRoute.waypoints
        route.shouldShowWishMarker = true
        return route
        
    }

}
