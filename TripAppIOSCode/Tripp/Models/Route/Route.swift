//
//  Route.swift
//  Tripp
//
//  Created by Bharat Lal on 05/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import RealmSwift

enum RoadType: Int {
    case easy = 1
    case intermediate
    case difficult
    case pro
    case completed
    case popular
}
enum TripType: Int {
    case None
    case Road
    case Aerial
    case Sea
}
enum TripMode: Int {
    case Manual = 1
    case Live
}
enum UserRole: Int{
    case None
    case Biker
    case Admin
    case AdMob
}
class Route: Object {
    
    @objc dynamic var tripId = 0
    @objc dynamic var groupId = 0
    @objc dynamic var name = ""
    @objc dynamic var role = UserRole.None.rawValue
    @objc dynamic var details = ""
    @objc dynamic var roadType = RoadType.easy.rawValue
    @objc dynamic var drivingMode = TripType.None.rawValue
    @objc dynamic var tripMode = TripMode.Manual.rawValue
    //dynamic var isCompleted = false
    @objc dynamic var isMyWish = false
    @objc dynamic var isMyTrip = false 
    @objc dynamic var isPopular = false
    @objc dynamic var routeImageCount = 0
    @objc dynamic var routeVideoCount = 0
    @objc dynamic var rank: String?
    @objc dynamic var createdAt = ""
    @objc dynamic var state = ""
    @objc dynamic var totalTime: String?
    @objc dynamic var distance = ""
    @objc dynamic var curviness: String?
    @objc dynamic var dateOfTrip: String?
    @objc dynamic var fileUrl: String?
    @objc dynamic var encodedPath: String?
    @objc dynamic var isAddedFromRoute = 0 // 0 if user created trip else route id
    @objc dynamic var currentLocation: LiveTripLocation?
    
    let categoryId = RealmOptional<Int>()
    
    var isCurrent = false
    var shouldShowWishMarker = false
    var states = List<TripState>()
    var waypoints = List<Wayponit>()
    var polylineString: NSString?
    
}
