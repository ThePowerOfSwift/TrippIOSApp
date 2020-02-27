//
//  APIDataSource+EditTrip.swift
//  Tripp
//
//  Created by Monu on 10/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation


extension APIDataSource {
    
    
    /**
     * @method addNewAsset
     * @discussion Add New Asset API.
     */
    class func addNewAsset(caption:String, sourcePath:String, type:Int, waypointId: Int, tripId:Int, handler: @escaping (_ message: String?, _ error: String?) -> ()) {
        let service = TripAPIService.addAsset(caption: caption, sourcePath: sourcePath, type: type, waypointId: waypointId, tripId: tripId)
        commonEditTripService(service: service, handler: handler)
    }
    
    /**
     * @method addNewAsset
     * @discussion Add New Asset API.
     */
    class func deleteMediaAsset(mediaId: Int, handler: @escaping (_ message: String?, _ error: String?) -> ()) {
        let service = TripAPIService.deleteAsset(mediaId: mediaId)
        commonEditTripService(service: service, handler: handler)
    }
    
    /**
     * @method addNewAsset
     * @discussion Add New Asset API.
     */
    class func deleteWaypoint(waypointId: Int, tripId: Int, handler: @escaping (_ message: String?, _ error: String?) -> ()) {
        let service = TripAPIService.deleteWaypoint(waypointId: waypointId, tripId: tripId)
        commonEditTripService(service: service, handler: handler)
    }
    
    /**
     * @method addNewAsset
     * @discussion Add New Asset API.
     */
    class func deleteTrip(tripId: Int, handler: @escaping (_ message: String?, _ error: String?) -> ()) {
        let service = TripAPIService.deleteTrip(tripId: tripId)
        commonEditTripService(service: service, handler: handler)
    }
    
    /**
     * @method commonUpdateService
     * @discussion Common service used for updating data on server and get only message.
     */
    class func commonEditTripService(service:TripAPIService, handler:@escaping (_ message: String?, _ error: String?) -> ()){
        Connection.callServiceWithName(service.method, serviceName: service.path, parameters: service.parameters) { (response, result) -> Void in
            if response.successful() {
                let webResponse = WebServiceResponse(result: result as! NSDictionary?)
                if webResponse.success{
                    if !webResponse.message.isEmpty {
                        handler(webResponse.message, nil)
                    }
                    else{
                        handler(nil, someErrorMessage)
                    }
                }else {
                    handler(nil, webResponse.message)
                }
            } else {
                handler(nil, someErrorMessage)
                showTryAgainAlert()
            }
        }
    }
    
}
