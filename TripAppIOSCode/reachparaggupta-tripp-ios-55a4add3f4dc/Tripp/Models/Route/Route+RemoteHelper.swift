//
//  Route+RemoteHelper.swift
//  Tripp
//
//  Created by Monu on 04/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

extension Route{
    
    func share(_ image: UIImage? = nil, shouldShareUrl: Bool = true){
        let message = "Trip Name: " + self.name + "\n" + "Trip Date: " + self.tripDate + " @AppTripp"
        let myWebsite = NSURL(string: iTuneLink)
        let shareImage: UIImage!
        if let img = image {
            shareImage = img
        }else{
            shareImage = UIImage(named:shareAppLogo)!
        }
        
        guard let url = myWebsite else {
            DLog(message: "nothing found" as AnyObject)
            return
        }
        if shouldShareUrl == true {
            ShareManager.share(shareItems: [message, shareImage, url])
        } else {
            ShareManager.share(shareItems: [message, shareImage])
        }
        
        AnalyticsManager.share(route: self)
    }
    
    class func share(_ image: UIImage, name: String, date: String){
        let message = "Trip Name: " + name + "\n" + "Trip Date: " + date + " @AppTripp"
        let myWebsite = NSURL(string: iTuneLink)
    
        guard let url = myWebsite else {
            DLog(message: "nothing found" as AnyObject)
            return
        }
        
        ShareManager.share(shareItems: [message, image, url])
    }
    func saveTrip(handler:@escaping (_ trip: Route? ,_ errorMessage: String?) -> ()){
        APIDataSource.addRoute(service: .addRoute(route: self.requestParameter())) { (trip, errorMessage) in
            handler(trip, errorMessage)
        }
    }
    
    
    func deleteTrip(handler:@escaping (_ message: String? ,_ error: String?) -> ()){
        APIDataSource.deleteTrip(tripId: tripId) { (message, error) in
            if error == nil{
                self.isMyTrip = false
               AppNotificationCenter.post(notification: AppNotification.deleteMyTrip, withObject: ["trip":self])
            }
            
            handler(message, error)
        }
    }
    
}
