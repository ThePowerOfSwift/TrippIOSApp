//
//  Place.swift
//  Tripp
//
//  Created by Bharat Lal on 01/09/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation
class Place: Object {
    
    @objc dynamic var placeId = 0
    @objc dynamic var name = ""
    @objc dynamic var primaryImage: String?
    @objc dynamic var about = ""
    @objc dynamic var latitude = ""
    @objc dynamic var longitude = ""
    @objc dynamic var isAddedToWishlist = 0
    @objc dynamic var isMarkedAsComplete = 0
    @objc dynamic var createdAt: String?
    var images = List<PlaceImage>()
}
extension Place {
    func share(){
        let date = createdAt == nil ? "" : createdAt?.convertFormatOfDate(AppDateFormat.sortDate)
        let message = "Name: " + name + "\n" + "Date: " + date! + " @AppTripp"
        let myWebsite = NSURL(string: iTuneLink)
        let img: UIImage = UIImage(named:shareAppLogo)!
        
        guard let url = myWebsite else {
            DLog(message: "nothing found" as AnyObject)
            return
        }
        
        ShareManager.share(shareItems: [message, img, url])
    }
    func coordinate() -> CLLocationCoordinate2D{
        let lat = Double(self.latitude)!
        let lon = Double(self.longitude)!
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
    }
}

