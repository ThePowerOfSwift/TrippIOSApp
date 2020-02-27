//
//  WishList.swift
//  Tripp
//
//  Created by Bharat Lal on 27/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import RealmSwift
enum WishListType: Int{
    case Route = 1
    case Location
    case Places
}
class WishList: Object {
    
    @objc dynamic var userWishlistId = 0
    @objc dynamic var tripId = 0
    @objc dynamic var imageCount = 0
    @objc dynamic var videoCount = 0
    
    @objc dynamic var trip: TripRoute?
    @objc dynamic var wishType = WishListType.Route.rawValue
    
    override static func primaryKey() -> String? {
        return "userWishlistId"
    }
    
    func share(){
        let name = self.trip?.name == nil ? "" : self.trip?.name
        let date = self.trip?.createdAt == nil ? "" : self.trip?.createdAt.convertFormatOfDate(AppDateFormat.sortDate)
        let message = "Name: " + name! + "\n" + "Date: " + date! + " @AppTripp"
        let myWebsite = NSURL(string: iTuneLink)
        let img: UIImage = UIImage(named:shareAppLogo)!
        
        guard let url = myWebsite else {
            DLog(message: "nothing found" as AnyObject)
            return
        }
        
        ShareManager.share(shareItems: [message, img, url])
    }
    
}

class TripRoute: Object{
    
    @objc dynamic var tripId = 0
    @objc dynamic var name = ""
    @objc dynamic var distance = ""
    @objc dynamic var createdAt = ""
    @objc dynamic var mapImage = ""
    @objc dynamic var isMyWish = false
    @objc dynamic var isMyTrip = false
    @objc dynamic var primaryImage: WaypointMedia?
    @objc dynamic var roadType = RoadType.easy.rawValue
    @objc dynamic var drivingMode = TripType.None.rawValue
    
    var waypoints = List<Wayponit>()
    override static func primaryKey() -> String? {
        return "tripId"
    }
    
}



