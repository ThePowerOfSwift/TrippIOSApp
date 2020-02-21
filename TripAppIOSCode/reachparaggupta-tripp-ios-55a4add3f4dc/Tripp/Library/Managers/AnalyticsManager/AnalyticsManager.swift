//
//  AnalyticsManager.swift
//  Tripp
//
//  Created by Monu on 08/09/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import Firebase

struct FirebaseEvent {
    static let signUp = "Sign_up"
    static let login = "Login"
    static let addTrip = "Trip_created"
    static let addWishList = "Route_added_to_wish_list"
    static let addLocationToWishList = "Location_added_to_wish_list"
    static let shareLocation = "Location_share"
    static let share = "Route_share"
    static let addToMyTrip = "Route_added_to_my_trip"
}

struct FirebaseKey {
    static let userId = "UserId"
    static let email = "Email"
    static let tripName = "TripName"
    static let date = "Date"
    static let type = "Type"
    static let mode = "Mode"
    static let name = "Name"
    static let latitude = "Latitude"
    static let longitude = "Longitude"
    static let address = "Address"
}

class AnalyticsManager {
    
    //MARK: Firebase Analytics Events
    
    //-- Log sign up events
    class func signUp() {
        Analytics.logEvent(FirebaseEvent.signUp, parameters: [FirebaseKey.userId:AppUser.currentUser().userId, FirebaseKey.email:AppUser.currentUser().email])
    }
    
    //-- Log login event
    class func login() {
        Analytics.logEvent(FirebaseEvent.login, parameters: [FirebaseKey.userId:AppUser.currentUser().userId, FirebaseKey.email:AppUser.currentUser().email])
    }
    
    //-- Log add trip event
    class func addTrip(trip:Route){
        Analytics.logEvent(FirebaseEvent.addTrip, parameters: paramsFrom(route: trip))
    }
    
    //-- Log share event
    class func share(route: Route){
        Analytics.logEvent(FirebaseEvent.share, parameters: paramsFrom(route: route))
    }
    
    //-- Log add to wish list event
    class func addToWishList(route:Route){
        Analytics.logEvent(FirebaseEvent.addWishList, parameters: paramsFrom(route: route))
    }
    
    //-- Log add to wish list event
    class func addToMyTrip(route:Route){
        Analytics.logEvent(FirebaseEvent.addToMyTrip, parameters: paramsFrom(route: route))
    }
    
    //-- Location share event
    class func shareLocation(location: LocationWish){
        Analytics.logEvent(FirebaseEvent.shareLocation, parameters: paramsFromLocation(location))
    }
    
    class func paramsFrom(route: Route) -> [String:Any]{
        let params:[String:Any] = [
            FirebaseKey.userId : AppUser.currentUser().userId,
            FirebaseKey.email : AppUser.currentUser().email,
            FirebaseKey.tripName : route.name,
            FirebaseKey.date : route.createdAt.convertFormatOfDate(AppDateFormat.sortDate),
            FirebaseKey.type : tripType(route.drivingMode),
            FirebaseKey.mode : route.tripMode == 1 ? "Mannual" : "Live"
        ]
        return params
    }
    
    class func paramsFromLocation(_ location: LocationWish) -> [String: Any]{
        let params:[String:Any] = [
            FirebaseKey.userId : AppUser.currentUser().userId,
            FirebaseKey.email : AppUser.currentUser().email,
            FirebaseKey.name : location.name ?? "",
            FirebaseKey.latitude : location.latitude,
            FirebaseKey.longitude : location.longitude,
            FirebaseKey.address : location.address ?? ""
        ]
        return params
    }
    
    class func tripType(_ type: Int) -> String {
        switch type {
        case 1:
            return "Road"
            
        case 2:
            return "Aerial"
            
        case 3:
            return "Sea"
            
        default:
            return "Admin Route"
        }
    }

}
