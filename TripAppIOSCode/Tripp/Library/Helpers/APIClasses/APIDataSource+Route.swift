//
//  APIDataSource+Route.swift
//  Tripp
//
//  Created by Monu on 01/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation


extension APIDataSource{
    
    /**
     * @method addRoute
     * @discussion Add new route API.
     */
    class func addRoute(service: APIService, handler: @escaping (_ trip: Route?, _ error: String?) -> ()){
        Connection.callServiceWithName(service.method, serviceName: service.path, parameters: service.parameters) { (response, result) -> Void in
            if response.successful() {
                
                let webResponse = WebServiceResponse(result: result as! NSDictionary?)
                if webResponse.success{
                    parseRouteDetail(webResponse: webResponse, handler: handler)
                }else {
                    handler(nil, webResponse.message)
                }
            } else {
                handler(nil, someErrorMessage)
                showTryAgainAlert()
            }
        }
    }
    
    /**
     * @method addMultipleRoutes
     * @discussion Add offline 1 or multiple route API.
     */
    class func addMultipleRoutes(service: APIService, handler: @escaping (_ isSuccess: Bool?, _ error: String?) -> ()){
        Connection.callServiceWithName(service.method, serviceName: service.path, parameters: service.parameters) { (response, result) -> Void in
            if response.successful() {
                print("addroute response\(response)")
                print("addroute result\(result)")
            
                
                let webResponse = WebServiceResponse(result: result as! NSDictionary?)
                if webResponse.success{
                    handler(webResponse.success,nil)
                }else {
                    handler(false, webResponse.message)
                }
            } else {
                handler(false, someErrorMessage)
                showTryAgainAlert()
            }
        }
    }

    /**
     * @method addRouteToWishList
     * @discussion Add an admin route to user wish list.
     */
    class func addRouteToWishList(service: APIService, handler: @escaping (_ message: String?, _ error: String?) -> ()){
        commonUpdateService(service: service, handler: handler)
    }
    /**
     * @method tripDetails
     * @discussion fetch details of a route (wish).
     */
    class func tripDetails(service: APIService, handler: @escaping (_ trip: Route?, _ error: String?) -> ()){
        Connection.callServiceWithName(service.method, serviceName: service.path, parameters: service.parameters) { (response, result) -> Void in
            if response.successful() {
                let webResponse = WebServiceResponse(result: result as! NSDictionary?)
                if webResponse.success{
                    parseRouteDetail(webResponse: webResponse, handler: handler)
                }else {
                    handler(nil, webResponse.message)
                }
            } else {
                handler(nil, someErrorMessage)
                showTryAgainAlert()
            }
        }
    }
    /**
     * @method addRouteToWishList
     * @discussion Add an admin route to user wish list.
     */
    class func removeRouteFromWishList(service: APIService, handler: @escaping (_ message: String?, _ error: String?) -> ()){
        commonUpdateService(service: service, handler: handler)
    }
    /**
     * @method fetchCategories
     * @discussion fetch available trip categories from server
     */
    
    class func fetchCategories(handler: ((_ categories: [Category]?, _ error: String?) -> ())?){
        let service: APIService = .categories
        Connection.callServiceWithName(service.method, serviceName: service.path, parameters: service.parameters) { (response, result) -> Void in
            if response.successful() {
                let webResponse = WebServiceResponse(result: result as! NSDictionary?)
                if webResponse.success{
                    parseCategories(webResponse: webResponse, handler: handler)
                }else {
                    if let _  = handler{
                        handler!(nil, webResponse.message)
                    }
                    
                }
            } else {
                if let _  = handler{
                    handler!(nil, someErrorMessage)
                }
                
            }
        }
    }
}
