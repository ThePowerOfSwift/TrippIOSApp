//
//  APIService.swift
//  Tripp
//
//  Created by Bharat Lal on 31/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import Alamofire

public enum APIService {
    
    public static let apiVersion = "v1"
    
    case login(username: String, password: String)
    case register(email: String, password: String)
    case forgotPassword(email: String)
    case resetPassword(newPassword: String, token: String)
    case updateProfile(fullName: String, profileImage: String, vehicleType:String, vehicleMake:String, vehicleModel: String, vehicleManufacturingYear: String)
    case wishList
    case updateUserName(name: String)
    case updateProfileImage(imageName: String)
    case updateVehicle(vehicleType:String, vehicleMake:String, vehicleModel: String, vehicleManufacturingYear: String)
    case changePassword(currentPassword: String, newPassword: String)
    case sendFeedback(feedback: String)
    case verifyPassword(password:String)
    case updateEmail(email:String)
    case logout
    case fetchRoutes(page: Int, lat: String, lon: String, filter: String)
    case addToMyTrip(tripId: Int,categoryId: String)
    case fetchTrips(page: Int, drivingMode: String?, isLive: Bool?, categoryId: String?, userId: Int?)
    case addRoute(route: [String:Any])
    case addMultipleRoutes(trips: [[String:Any]])
    case addToMyWish(tripId: Int)
    case updateDeviceToken(deviceToken: String)
    case fetchTripDetail(tripId: Int)
    case removeFromWishList(tripId: Int)
    case states
    case addLocationWish(latitude: String, longitude: String, address: String, name: String, date: String)
    case deleteLocationWish(locationWishlistId: Int)
    case locationWishList
    case editTrip(route: [String:Any])
    case userProfile(userId: Int?)
    case categories
    case completeLcationWish(wishId: Int)
    case createGroup(name: String, image: String?, groupId: Int?)
    case inviteMember(groupId: Int, email: String)
    case groupList(page: Int)
    case groupMemberList(groupId: Int, page: Int)
    case userNotification
    case createFeed(tripId: Int, groupId: Int)
    case likeFeed(feedId: Int)
    case feedsByGroup(groupId: Int, page: Int)
    case upadteGroupMemnerStatus(groupId: Int, status: Int)
    case removeMember(groupId: Int, memberEmailId: String)
    case shareTripWithGroup(groupId: Int, tripId: Int)
    case groupInfo(groupId: Int)
    case memberShipExpiry(date: String)
    case placeCategories(page: Int)
    case places(placeCategoryId: Int)
    case placeDetails(placeId: Int)
    case addCategoryToWishlist(categoryId: Int)
    case addPlaceoWishlist(placeId: Int)
    case markPlaceAsCompleted(placeId: Int)
    case purchaseCategory(placeCategoryId: Int)
    case placeWishList()
    case placeCompletedList()
    var path: String {
        switch self { //please do not use default case
            
        case .login:
            return "user/sign-in"
            
        case .register:
            return "user/sign-up"
            
        case .forgotPassword:
            return "user/forgot-password"
            
        case .resetPassword:
            return "user/reset-password"
            
        case .updateProfile, .updateProfileImage, .updateUserName, .updateVehicle, .updateEmail:
            return "user/update-profile"
        case .wishList:
            return "user/user-wish-list"
            
        case .changePassword:
            return "user/change-password"
            
        case .sendFeedback:
            return "user/user-feedback"
            
        case .verifyPassword:
            return "user/confirm-password"
            
        case .addToMyTrip:
            return "user/add-to-my-trip"
            
        case .logout:
            return "user/sign-out"
        case .fetchRoutes:
            return "user/user-routes"
        case .fetchTrips:
            return "user/user-trip-list"
            
        case .addRoute:
            return "user/add-trip"
            
        case .addMultipleRoutes:
            return "user/add-multiple-trip"
            
        case .addToMyWish:
            return "user/add-wish-list"
            
        case .updateDeviceToken:
            return "user/update-device-token"
        case .fetchTripDetail:
            return "user/trip-details"
        case .removeFromWishList:
            return "user/delete-wish-list"
        case .states:
            return "user/trip-state-list"
        case .addLocationWish:
            return "user/add-location-wish-list"
        case .deleteLocationWish:
            return "user/delete-location-wish-list"
        case .locationWishList:
            return "user/location-wish-list"
        case .editTrip:
            return "user/edit-trip"
        case .userProfile:
            return "user/my-profile"
        case .userNotification:
            return "user/notifications-list"
        case .categories:
            return "category/list"
        case .completeLcationWish:
            return "user/complete-location-wish-list"
        case .createGroup:
            return "group/create"
        case .inviteMember:
            return "group/invite"
        case .groupList:
            return "group/list"
        case .groupMemberList:
            return "group/members"
        case .createFeed:
            return "feed/create"
        case .likeFeed:
            return "feed/like"
        case .feedsByGroup:
            return "feed/by-group"
        case .upadteGroupMemnerStatus:
            return "group/update-member-status"
        case .removeMember:
            return "group/delete-member"
        case .shareTripWithGroup:
            return "feed/create"
        case .groupInfo:
            return "group/info"
        case .memberShipExpiry:
            return "user/update-membership-expiry"
        case .placeCategories:
            return "place-category/list"
        case .places:
            return "place/list"
        case .placeDetails:
            return "place/details"
        case .addCategoryToWishlist:
            return "place/add-all-to-wishlist"
        case .addPlaceoWishlist:
            return "place/add-to-wishlist"
        case .markPlaceAsCompleted:
             return "place/mark-as-complete"
        case .purchaseCategory:
            return "place-category/purchase"
        case .placeWishList:
            return "place/wishlist"
        case .placeCompletedList:
            return "place/completed-list"
            
        }
    }
    
    var parameters: [String: Any] {
        switch self { //please do not use default case
        case let .login(username, password):
            let params = ["email": username, "password": password, "deviceType": "iOS", "deviceToken": ""] as [String : Any]
            return params
            
        case let .register(email, password):
            let params = ["email": email, "password": password, "deviceType": "iOS", "deviceToken": ""] as [String : Any]
            return params
            
        case let .forgotPassword(email):
            let params = ["email": email] as [String : Any]
            return params
            
        case let .resetPassword(newPassword, token):
            let params = ["newPassword": newPassword, "token":token] as [String : Any]
            return params
            
        case let .updateProfile(fullName, profileImage, vehicleType, vehicleMake, vehicleModel, vehicleManufacturingYear):
            let params = ["fullName":fullName, "profileImage":FileType.profile.rawValue+profileImage, "vehicleType":vehicleType, "vehicleMake":vehicleMake, "vehicleModel":vehicleModel, "vehicleManufacturingYear":vehicleManufacturingYear] as [String : Any]
            return params
        case .wishList, .logout, .states , .locationWishList, .categories, .userNotification, .placeWishList, .placeCompletedList:
            return ["":""]
        case let .userProfile(userId):
            
            if let uID = userId {
                 return ["userId": uID]
            } else {
                return ["":""]
            }
           
        case let .updateUserName(name):
            return ["fullName":name]
        case let .updateProfileImage(imageName):
            return ["profileImage": FileType.profile.rawValue + imageName]
        case let .updateVehicle(vehicleType, vehicleMake, vehicleModel, vehicleManufacturingYear):
            return ["vehicleType":vehicleType, "vehicleMake":vehicleMake, "vehicleModel":vehicleModel, "vehicleManufacturingYear":vehicleManufacturingYear] as [String : Any]
            
        case let .changePassword(currentPassword, newPassword):
            return ["currentPassword":currentPassword, "newPassword":newPassword]
            
        case let .sendFeedback(feedback):
            return ["feedback":feedback]
            
        case let .verifyPassword(password):
            return ["password":password]
            
        case let .updateEmail(email):
            return ["email": email]
            
        case let .addToMyWish(tripId), let .fetchTripDetail(tripId), let .removeFromWishList(tripId):
            return ["tripId": tripId]
        
        case let .addToMyTrip(tripId,categoryId):
            return ["tripId": tripId, "categoryId": categoryId]
            
        case let .fetchRoutes(page, lat, lon, filter):
            return ["page": page, "lat": lat, "lon": lon, "filter": filter]
        case let .fetchTrips(page, drivingMode, isLive, categoryId, userId):
            var params = [String : Any]()
            if let mode = drivingMode{
                params["drivingMode"] = mode
            }
            if let live = isLive{
                params["isLive"] = live
            }
            if let categories = categoryId{
                params["categoryId"] = categories
            }
            if let uID = userId {
                params["userId"] = uID
            }
            params["page"] = page
            return params
            
        case let .addRoute(route):
            return route
       
        case let .addMultipleRoutes(trips):
            return ["trips" : trips]
        case let .updateDeviceToken(deviceToken):
            return ["deviceToken": deviceToken]
        case let .addLocationWish(latitude, longitude, address, name, date):
            return ["latitude": latitude, "longitude": longitude, "address": address, "name": name, "date": date]
        case let .deleteLocationWish(locationWishlistId):
            return ["locationWishlistId": locationWishlistId]
            
        case let .editTrip(route):
            return route
        case let .completeLcationWish(wishId):
            return ["locationWishlistId": wishId]
        case let .createGroup(name, image, groupId):
            var params = ["name": name, "image": image ?? ""] as [String : Any]
            if let gID = groupId {
                params["groupId"] = gID
            }
            return params
        case let .inviteMember(groupId, email):
            return ["email": email, "groupId": groupId]
        case let .groupList(page):
            return ["page": page]
        case let .groupMemberList(groupId, page):
            return ["groupId": groupId, "page": page]
        case let .createFeed(tripId, groupId):
            return ["tripId": tripId, "groupId": groupId]
        case let .likeFeed(feedId):
            return ["feedId": feedId]
        case let .feedsByGroup(groupId, page):
            return ["groupId": groupId, "page": page]
        case let .upadteGroupMemnerStatus(groupId, status):
            return ["groupId": groupId, "status": status]
        case let .removeMember(groupId, memberEmailId):
            return ["groupId": groupId, "email": memberEmailId]
        case let .shareTripWithGroup(groupId, tripId):
            return ["groupId": groupId, "tripId": tripId]
        case let .groupInfo(groupId):
            return  ["groupId": groupId]
        case let .memberShipExpiry(date):
            return ["date": date]
        case let .places(placeCategoryId), let .purchaseCategory(placeCategoryId):
            return ["placeCategoryId": placeCategoryId]
        case let .placeDetails(placeId):
            return ["placeId": placeId]
        case let .placeCategories(page):
            return ["page": page]
        case let .addCategoryToWishlist(categoryId):
            return ["categoryId": categoryId]
        case let .addPlaceoWishlist(placeId), let .markPlaceAsCompleted(placeId):
            return ["placeId": placeId]

        }
    }
    
    var method: HTTPMethod {
        switch self { //please do not use default case
        case .login, .register, .resetPassword, .sendFeedback, .verifyPassword, .addToMyTrip, .addRoute,.addMultipleRoutes ,.updateDeviceToken, .addToMyWish, .fetchTripDetail, .removeFromWishList, .addLocationWish, .deleteLocationWish, .editTrip,.createGroup, .inviteMember, .createFeed, .likeFeed, .upadteGroupMemnerStatus, .removeMember, .shareTripWithGroup, .memberShipExpiry, .addCategoryToWishlist, .addPlaceoWishlist, .markPlaceAsCompleted, .purchaseCategory:
            return .post
        case .forgotPassword, .updateProfile, .updateProfileImage, .updateUserName, .updateVehicle, .changePassword, .logout, .updateEmail, .completeLcationWish:
            return .put
        case .wishList, .fetchRoutes, .fetchTrips, .states, .locationWishList, .userProfile, .categories, .userNotification, .groupList, .groupMemberList, .feedsByGroup, .groupInfo, .placeCategories, .placeDetails, .places, .placeWishList, .placeCompletedList:
            return .get
            
        }
    }
    
}
