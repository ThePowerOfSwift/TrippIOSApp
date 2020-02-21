//
//  APIDataSource+Places.swift
//  Tripp
//
//  Created by Bharat Lal on 31/08/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import Foundation
extension APIDataSource {
    class func fetchPlacesCategories(service: APIService, handler: @escaping (_ categories: [PlaceCategory]?, _ page: Paging?, _ error: String?) -> ()){
        Connection.callServiceWithName(service.method, serviceName: service.path, parameters: service.parameters) { (response, result) -> Void in
            if response.successful() {
                let webResponse = WebServiceResponse(result: result as! NSDictionary?)
                if webResponse.success{
                    parseCategories(webResponse: webResponse, handler: handler)
                }else {
                    handler(nil, nil, webResponse.message)
                }
            } else {
                handler(nil, nil, someErrorMessage)
            }
        }
    }
    class func fetchPlaceWithImages(service: APIService, handler: @escaping (_ categories: Place?, _ error: String?) -> ()){
        Connection.callServiceWithName(service.method, serviceName: service.path, parameters: service.parameters) { (response, result) -> Void in
            if response.successful() {
                let webResponse = WebServiceResponse(result: result as! NSDictionary?)
                if webResponse.success{
                    parsePlaceImages(webResponse: webResponse, handler: handler)
                }else {
                    handler(nil, webResponse.message)
                }
            } else {
                handler(nil, someErrorMessage)
            }
        }
    }
    class func fetchPlacesFromCategory(service: APIService, handler: @escaping (_ places: [Place]?, _ error: String?) -> ()){
        Connection.callServiceWithName(service.method, serviceName: service.path, parameters: service.parameters) { (response, result) -> Void in
            if response.successful() {
                let webResponse = WebServiceResponse(result: result as! NSDictionary?)
                if webResponse.success{
                    parsePlaces(webResponse: webResponse, handler: handler)
                }else {
                    handler(nil, webResponse.message)
                }
            } else {
                handler(nil, someErrorMessage)
            }
        }
    }
    class func fetchPlacesWishOrCompletedList(service: APIService, handler: @escaping (_ places: [Place]?, _ error: String?) -> ()){
        Connection.callServiceWithName(service.method, serviceName: service.path, parameters: service.parameters) { (response, result) -> Void in
            if response.successful() {
                let webResponse = WebServiceResponse(result: result as! NSDictionary?)
                if webResponse.success{
                    parsePlacesWishList(webResponse: webResponse, handler: handler)
                }else {
                    handler(nil, webResponse.message)
                }
            } else {
                handler(nil, someErrorMessage)
            }
        }
    }
    class func addCategoryToWishList(service: APIService, handler: @escaping (_ message: String?, _ error: String?) -> ()) {
        commonUpdateService(service: service, handler: handler)
    }
    class func addPlaceToWishList(service: APIService, handler: @escaping (_ message: String?, _ error: String?) -> ()) {
        commonUpdateService(service: service, handler: handler)
    }
    class func markPlaceAsComplete(service: APIService, handler: @escaping (_ message: String?, _ error: String?) -> ()) {
        commonUpdateService(service: service, handler: handler)
    }
    class func purchaseCategory(service: APIService, handler: @escaping (_ message: String?, _ error: String?) -> ()) {
        commonUpdateService(service: service, handler: handler)
    }
    //MARK: parser
    private class func parsePlaces(webResponse: WebServiceResponse, handler: @escaping (_ places: [Place]?, _ error: String?) -> ()){
        let dataDict = webResponse.result as! Dictionary<String, AnyObject>
        if !dataDict.isEmpty {
            var feeds = [Place]()
            guard let feedsArray = dataDict["places"] as? [Any] else {
                handler(nil, someErrorMessage)
                return
            }
            for data in feedsArray{
                let place = Place(value: data)
                feeds.append(place)
            }
            handler(feeds, nil)
        }
        else {
            handler(nil, someErrorMessage)
        }
    }
    private class func parsePlacesWishList(webResponse: WebServiceResponse, handler: @escaping (_ places: [Place]?, _ error: String?) -> ()){
        let dataDict = webResponse.result as! Dictionary<String, AnyObject>
        if !dataDict.isEmpty {
            var feeds = [Place]()
            guard let feedsArray = dataDict["places"] as? [Any] else {
                handler(nil, someErrorMessage)
                return
            }
            for data in feedsArray{
                let place = Place(value: data)
                feeds.append(place)
            }
            handler(feeds, nil)
        }
        else {
            handler(nil, someErrorMessage)
        }
    }
    private class func parseCategories(webResponse: WebServiceResponse, handler: @escaping (_ categories: [PlaceCategory]?, _ page: Paging?, _ error: String?) -> ()){
        let dataDict = webResponse.result as! Dictionary<String, AnyObject>
        if !dataDict.isEmpty {
            var feeds = [PlaceCategory]()
            guard let feedDictionary = dataDict["categories"] else {
                handler(nil, nil, someErrorMessage)
                return
            }
            guard let feedsArray = feedDictionary["data"] as? [Any] else {
                handler(nil, nil, someErrorMessage)
                return
            }
            for data in feedsArray{
                let category = PlaceCategory(value: data)
                feeds.append(category)
            }
            let page = Paging(value: feedDictionary)
            handler(feeds, page, nil)
        }
        else {
            handler(nil, nil, someErrorMessage)
        }
    }
    
    private class func parsePlaceImages(webResponse: WebServiceResponse, handler: @escaping (_ place: Place?, _ error: String?) -> ()){
        let dataDict = webResponse.result as! Dictionary<String, AnyObject>
        if !dataDict.isEmpty {
            let place = Place(value: dataDict)
            handler(place, nil)
        }
        else {
            handler(nil, someErrorMessage)
        }
    }
}
