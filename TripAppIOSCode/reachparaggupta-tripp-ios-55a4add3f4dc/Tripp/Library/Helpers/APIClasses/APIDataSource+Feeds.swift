//
//  APIDataSource+Feeds.swift
//  Tripp
//
//  Created by Bharat Lal on 13/05/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import Foundation
extension APIDataSource {
    class func createFeed(service: APIService, handler: @escaping (_ feed: Feed?, _ error: String?) -> ()){
        Connection.callServiceWithName(service.method, serviceName: service.path, parameters: service.parameters) { (response, result) -> Void in
            if response.successful() {
                let webResponse = WebServiceResponse(result: result as! NSDictionary?)
                if webResponse.success{
                    if let dataDict = webResponse.result as? Dictionary<String, Any> {
                        if !dataDict.isEmpty {
                            let feed = Feed(value: dataDict["feed"] as! [String:Any])
                            handler(feed, nil)
                        }
                    }else {
                        handler(nil, webResponse.message)
                    }
                    
                }else {
                    handler(nil, webResponse.message)
                }
            } else {
                handler(nil, someErrorMessage)
            }
        }
    }
    class func toggleLike(service: APIService, handler: @escaping (_ message: String?, _ error: String?) -> ()){
        APIDataSource.commonUpdateService(service: service, handler: handler)
    }
    class func feedByGroup(service: APIService, handler: @escaping (_ feeds: [FeedData]?, _ page: Paging?, _ error: String?) -> ()) {
        Connection.callServiceWithName(service.method, serviceName: service.path, parameters: service.parameters) { (response, result) -> Void in
            if response.successful() {
                let webResponse = WebServiceResponse(result: result as! NSDictionary?)
                if webResponse.success{
                    parseFeeds(webResponse: webResponse, handler: handler)
                }else {
                    handler(nil, nil, webResponse.message)
                }
            } else {
                handler(nil, nil, someErrorMessage)
            }
        }
    }
    class func parseFeeds(webResponse: WebServiceResponse, handler: @escaping (_ feeds: [FeedData]?, _ page: Paging?, _ error: String?) -> ()){
        let dataDict = webResponse.result as! Dictionary<String, AnyObject>
        if !dataDict.isEmpty {
            var feeds = [FeedData]()
            guard let feedDictionary = dataDict["feeds"] else {
                handler(nil, nil, someErrorMessage)
                return
            }
            guard let feedsArray = feedDictionary["data"] as? [Any] else {
                handler(nil, nil, someErrorMessage)
                return
            }
            for data in feedsArray{
                let feed = FeedData(value: data)
                feeds.append(feed)
            }
            let page = Paging(value: feedDictionary)
            handler(feeds, page, nil)
        }
        else {
            handler(nil, nil, someErrorMessage)
        }
    }
}
