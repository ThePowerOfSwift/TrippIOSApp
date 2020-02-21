//
//  APIDataSource+Parser.swift
//  Tripp
//
//  Created by Monu on 19/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import GoogleMaps

extension APIDataSource {
    
    /**
     * @method parseUser
     * @discussion Parse user response when user logged in or sign up.
     */
    class func parseUser(response:DataServiceResponse, result:NSDictionary?, handler: @escaping (_ user: AppUser?, _ error: String?) -> ()){
        if response.successful() {
            let webResponse = WebServiceResponse(result: result)
            if webResponse.success{
                let dataDict = webResponse.result as! Dictionary<String, AnyObject> // for example you can change according to your response
                (!dataDict.isEmpty) ? handler(AppUser(value: (dataDict["user"])!), nil) : handler(nil, someErrorMessage)
            }else {
                handler(nil, webResponse.message)
            }
        } else {
            handler(nil, someErrorMessage)
            showTryAgainAlert()
        }
    }
    
    /**
     * @method parseUpdateUser
     * @discussion Parse user response after update user details.
     */
    class func parseUpdateUser(webResponse: WebServiceResponse, handler: @escaping (_ user: AppUser?, _ error: String?) -> ()){
        let dataDict = webResponse.result as! Dictionary<String, Any>
        if !dataDict.isEmpty {
            let user = AppUser(value: dataDict["user"] as! [String:Any])
            if user.isComplete == true{
                appDelegate.cancelAllLocalNotifications()
            }
            handler(user, nil)
        }
        else {
            handler(nil, someErrorMessage)
        }
    }
    
    /**
     * @method parseWishList
     * @discussion Parse user wish list.
     */
    class func parseWishList(webResponse: WebServiceResponse, handler: @escaping (_ wishList: [WishList]?, _ error: String?) -> ()){
        let dataDict = webResponse.result as! Dictionary<String, AnyObject>
        if !dataDict.isEmpty {
            var wishList = [WishList]()
            let wishArray = (dataDict["wishList"]) as! [Any]
            for data in wishArray{
                let wish = WishList(value: data)
                wishList.append(wish)
            }
            handler(wishList, nil)
        }
        else {
            handler(nil, someErrorMessage)
        }
    }
    class func parseLocationWishList(webResponse: WebServiceResponse, handler: @escaping (_ wishList: [LocationWish]?, _ error: String?) -> ()){
        let dataDict = webResponse.result as! Dictionary<String, AnyObject>
        if !dataDict.isEmpty {
            var wishList = [LocationWish]()
            let wishArray = (dataDict["data"]) as! [Any]
            for data in wishArray{
                let wish = LocationWish(value: data)
                wishList.append(wish)
            }
            handler(wishList, nil)
        }
        else {
            handler(nil, someErrorMessage)
        }
    }
    /**
     * @method parseStates
     * @discussion Parse states API response.
     */
    class func parseStates(webResponse: WebServiceResponse, handler: ((_ stateList: [State]?, _ error: String?) -> ())?){
        let dataDict = webResponse.result as! Dictionary<String, AnyObject>
        if !dataDict.isEmpty {
            var stateList = [State]()
            let stateArray = (dataDict["states"]) as! [Any]
            for data in stateArray{
                let state = State(value: data)
                state.saveState()
                stateList.append(state)
            }
            if let _  = handler{
                handler!(stateList, nil)
            }
        }
        else {
            if let _  = handler{
                handler!(nil, someErrorMessage)
            }
        }
    }
    class func parseNotifications(webResponse: WebServiceResponse, handler: ((_ notifications: [UserNotification]?, _ error: String?) -> ())){
        let dataDict = webResponse.result as! Dictionary<String, AnyObject>
        if !dataDict.isEmpty {
            var notificationList = [UserNotification]()
            let notificationArray = (dataDict["data"]) as! [Any]
            for data in notificationArray{
                let notification = UserNotification(value: data)
                notificationList.append(notification)
            }
                handler(notificationList, nil)
        }
        else {
                handler(nil, someErrorMessage)
        }
    }
    /**
     * @method parseCategories
     * @discussion Parse Categories API response.
     */
    class func parseCategories(webResponse: WebServiceResponse, handler: ((_ categories: [Category]?, _ error: String?) -> ())?){
        let dataDict = webResponse.result as! Dictionary<String, AnyObject>
        if !dataDict.isEmpty {
            var categoryList = [Category]()
            let categoryArray = (dataDict["categories"]) as! [Any]
            for data in categoryArray{
                let state = Category(value: data)
                categoryList.append(state)
            }
            if let _  = handler{
                handler!(categoryList, nil)
            }
        }
        else {
            if let _  = handler{
                handler!(nil, someErrorMessage)
            }
        }
    }
    /**
     * @method parseRoutes
     * @discussion Parse admin routes.
     */
    class func parseRoutes(webResponse: WebServiceResponse, handler: @escaping (_ routes: [Route]?, _ totalPage: Int?, _ perPageCount: Int?, _ error: String?) -> ()){
        let dataDict = webResponse.result as! Dictionary<String, AnyObject>
        if !dataDict.isEmpty {
            var routes = [Route]()
            let routesArray = (dataDict["data"]) as! [Any]
            for data in routesArray{
                let route = Route(value: data)
                routes.append(route)
            }
            let totalPage = dataDict["lastPage"] as! Int
            let perPage = dataDict["perPage"] as! Int
            handler(routes, totalPage, perPage, nil)
        }
        else {
            handler(nil, 0, 0,someErrorMessage)
        }
    }
    /**
     * @method parseRoutes
     * @discussion Parse admin routes.
     */
    class func parseRouteDetail(webResponse: WebServiceResponse, handler: @escaping (_ routes: Route?, _ error: String?) -> ()){
        if let dataDict = webResponse.result as? Dictionary<String, AnyObject> {
            if !dataDict.isEmpty {
                let trip = Route(value: dataDict["trip"] as! [String:Any])
                handler(trip, nil)
            }
            else {
                handler(nil,someErrorMessage)
            }
        }
        else {
            handler(nil,someErrorMessage)
        }
    }
    // direction API
    class func parseDirectionResponse(response: [String: Any]) -> GooglePath?{
        
        if response["status"] as! String == okayButtonTitle {
            let routes = response["routes"] as? [Any]
            let route = routes?[0] as? [String:Any]
            
            
            var googlePath = GooglePath()
            var mutablePath = GMSMutablePath()
            googlePath.distance = 0.0
            googlePath.duration = 0.0
            
            
            if let legs = route?["legs"] as? [[String : Any]] {
                polylineFromLegs(legs, googlePath: &googlePath, mutablePath: &mutablePath)
            }
            else{
                let overview_polyline = route?["overview_polyline"] as?[String:Any]
                googlePath.polyline = overview_polyline?["points"] as! NSString
            }
            
            return googlePath
        }else{
            return nil
        }
    }
    
    class func polylineFromLegs(_ legs:[[String:Any]], googlePath: inout GooglePath, mutablePath: inout GMSMutablePath){
        for leg in legs {
            let pathDetail = leg as? [String:Any]
            if let steps = pathDetail?["steps"] as? [[String:Any]] {
                coordinateFromSteps(steps, mutablePath: &mutablePath)
            }
            
            //-- Parse Distance and duration
            let distance = pathDetail?["distance"] as? [String:Any]
            let duration = pathDetail?["duration"] as? [String:Any]
            googlePath.distance = googlePath.distance + (distance?["value"] as! Double) //-- Distance in meters
            googlePath.duration = googlePath.duration + (duration?["value"] as! Double) //-- Duration in seconds
        }
        googlePath.polyline = mutablePath.encodedPath() as NSString
    }
    
    class func coordinateFromSteps(_ steps:[[String:Any]], mutablePath: inout GMSMutablePath){
        for step in steps {
            let polyline = step["polyline"] as? [String:Any]
            if let points = polyline?["points"] as? String {
                let path = GMSPath(fromEncodedPath: points)
                var index = 0 as UInt
                let count = path?.count() ?? 0 as UInt
                while index < count {
                    mutablePath.add((path?.coordinate(at: index))!)
                    index += 1
                }
            }
        }
    }
    
    // Places API parser
    class func parsePlaceResponse(response: [String:Any]) -> [NearByPlace]?{
        if response["status"] as! String == okayButtonTitle, let results = response["results"] as? [[String:Any]] {
            var places: [NearByPlace] = []
            for place in results {
                places.append(NearByPlace(value: place))
            }
            return places
        }
        return []
    }
    class func parseSearchPlaceResponse(response: [String:Any]) -> [NearByPlace]?{
        if response["status"] as! String == okayButtonTitle, let results = response["predictions"] as? [[String:Any]] {
            var places: [NearByPlace] = []
            for place in results {
                places.append(NearByPlace(value: place))
            }
            return places
        }
        return []
    }
}
