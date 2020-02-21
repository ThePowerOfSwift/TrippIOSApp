//
//  LocationWish+Helper.swift
//  Tripp
//
//  Created by Bharat Lal on 16/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import  UIKit
import CoreLocation

extension LocationWish{
    func share(){
        let name = self.name == nil ? "" : self.name
        let date = self.createdAt == nil ? "" : self.createdAt!
        
        let message = "Name: " + name! + "\n" + "Date: " + date + " @AppTripp"
        let myWebsite = NSURL(string: iTuneLink)
        let img: UIImage = UIImage(named: shareAppLogo)!
        
        guard let url = myWebsite else {
            DLog(message: "nothing found" as AnyObject)
            return
        }
        
        ShareManager.share(shareItems: [message, img, url])
        AnalyticsManager.shareLocation(location: self)
    }
    func coordinate() -> CLLocationCoordinate2D{
        let lat = Double(self.latitude)!
        let lon = Double(self.longitude)!
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
    }
    
    //remove from wish list
    func removeFromWishList(handler: @escaping (_ message: String?, _ error: String?) -> ()){
        APIDataSource.removeLocationFromWistList(service: .deleteLocationWish(locationWishlistId: self.locationWishlistId)) { (message, error) in
            if error == nil{
                AppNotificationCenter.post(notification: AppNotification.deleteLocationWish, withObject: ["locationWish":self])
                
            }
            handler(message, error)
        }
    }
    func completeWish(handler: @escaping (_ message: String?, _ error: String?) -> ()) {
        APIDataSource.completeWish(service: .completeLcationWish(wishId: self.locationWishlistId)) { (message, error) in
            if error == nil{
               // AppNotificationCenter.post(notification: AppNotification.completeLocationWish, withObject: nil)
                self.isCompleted = 1
            }
            handler(message, error)
        }
    }
}
