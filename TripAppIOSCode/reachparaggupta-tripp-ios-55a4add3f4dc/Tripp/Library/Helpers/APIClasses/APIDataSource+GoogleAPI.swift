//
//  APIDataSource+GoogleAPI.swift
//  Tripp
//
//  Created by Bharat Lal on 06/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces
import Alamofire

extension APIDataSource{
    
    class func fetchRoutePolylineFrom(_ origin: String, destination: String, waypoints: [String]?, completionHandler: @escaping (_ googlePath: GooglePath?)->()){
        
        var waypointsString = ""
        if let routeWaypoints = waypoints {
            waypointsString += "optimize:false"
            
            for waypoint in routeWaypoints {
                waypointsString += "|" + waypoint
            }
        }
        
        var params: [String: String] = ["sensor": "false"]
        params["mode"] = "driving"
        params["origin"] = origin
        params["destination"] = destination
        params["key"] = ConfigurationManager.googleServicesAPIKey()
        if let points = waypoints, points.count > 0{
            params["waypoints"] = waypointsString
        }
        
        Alamofire.request(googleDirectionAPIBaseURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            logAPIResponse(response: response)
            switch response.result {
            case .success:
                completionHandler(response.response?.statusCode == SUCCESS_CODE ? self.parseDirectionResponse(response: response.result.value as! [String: Any]) : nil)
            case .failure(_):
                completionHandler( nil)
            }
        }
    }
    
    // Google places API
    class func fetchPlaces(params: [String: Any], completion: @escaping (_ places:[NearByPlace]?, _ nextPageToken: String?, _ error: Error?) -> ()){        
        Alamofire.request(googlePlaceAPIBaseURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            logAPIResponse(response: response)
            switch response.result {
            case .success:
                let statusCode = response.response?.statusCode
                if statusCode == SUCCESS_CODE {
                    completion(self.parsePlaceResponse(response: response.result.value as! [String: Any]), self.nextPageTokenForPlace(response: response.result.value as! [String: Any]), nil)
                }
            case .failure(_):
                completion( nil, "", nil)
            }
        }
    }
    
    class func nextPageTokenForPlace(response: [String:Any]) -> String{
        if let nextPage = response["next_page_token"] as? String{
            return nextPage
        }
        return ""
    }
    // Google search for places API
    class func searchPlaces(params: [String: Any], completion: @escaping (_ places:[NearByPlace]?, _ error: Error?) -> ()){
        if !Connection.isInternetAvailable() {
            AppLoader.hideLoader()
            Utils.mainQueue({ () -> () in
                AppToast.showErrorMessage(message: internetConectionError)
            })
            completion( nil, nil)
            return
        }
        
        Alamofire.request(googleSearchPlaceAPIBaseURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            logAPIResponse(response: response)
            switch response.result {
            case .success:
                let statusCode = response.response?.statusCode
                if statusCode == SUCCESS_CODE {
                    completion(self.parseSearchPlaceResponse(response: response.result.value as! [String: Any]), nil)
                }
            case .failure(_):
                completion( nil, nil)
            }
        }
    }
    
    //MARK: Helper functions
    class func waypointFromCoordinate(coordinate: CLLocationCoordinate2D, drivingMode: Int, handler:@escaping (_ waypoint: Wayponit?)->()) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            guard let response = response else{
                if drivingMode == TripType.Sea.rawValue {
                    handler(Wayponit.createWaypointWithCordinate(coordinate, waypointIndex: 1))
                }else{
                    handler(nil)
                }
                return
            }
            
            if let address = response.firstResult() {
                handler(Wayponit.createWaypointFromAddress(address))
                
            }else{
                handler(nil)
            }
        }
    }
}
