//
//  APIDataSource+Groups.swift
//  Tripp
//
//  Created by Bharat Lal on 12/05/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import Foundation
extension APIDataSource {
    /**
     * @method createGroup
     * @discussion create a group so that user can add members
     */
    class func createGroup(service: APIService, handler: @escaping (_ group: Group?, _ error: String?) -> ()){
        Connection.callServiceWithName(service.method, serviceName: service.path, parameters: service.parameters) { (response, result) -> Void in
            if response.successful() {
                let webResponse = WebServiceResponse(result: result as! NSDictionary?)
                if webResponse.success{
                    if let dataDict = webResponse.result as? Dictionary<String, Any> {
                        if !dataDict.isEmpty {
                            let group = Group(value: dataDict["group"] as! [String:Any])
                            handler(group, nil)
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
    class func inviteGroupMember(service: APIService, handler: @escaping (_ member: GroupMember?, _ error: String?) -> ()){
        Connection.callServiceWithName(service.method, serviceName: service.path, parameters: service.parameters) { (response, result) -> Void in
            if response.successful() {
                let webResponse = WebServiceResponse(result: result as! NSDictionary?)
                if webResponse.success{
                    if let dataDict = webResponse.result as? Dictionary<String, Any> {
                        if !dataDict.isEmpty {
                            let member = GroupMember(value: dataDict["groupUser"] as! [String:Any])
                            handler(member, nil)
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
    class func groupListing(service: APIService, handler: @escaping (_ groups: [Group]?, _ page: Paging?, _ error: String?) -> ()){
        Connection.callServiceWithName(service.method, serviceName: service.path, parameters: service.parameters) { (response, result) -> Void in
            if response.successful() {
                let webResponse = WebServiceResponse(result: result as! NSDictionary?)
                if webResponse.success{
                    parseGroups(webResponse: webResponse, handler: handler)
                }else {
                    handler(nil, nil, webResponse.message)
                }
            } else {
                handler(nil, nil, someErrorMessage)
            }
        }
    }
    class func groupMemberListing(service: APIService, handler: @escaping (_ groupMembers: [GroupMember]?, _ page: Paging?, _ error: String?) -> ()){
        Connection.callServiceWithName(service.method, serviceName: service.path, parameters: service.parameters) { (response, result) -> Void in
            if response.successful() {
                let webResponse = WebServiceResponse(result: result as! NSDictionary?)
                if webResponse.success{
                    parseGroupMembers(webResponse: webResponse, handler: handler)
                }else {
                    handler(nil, nil, webResponse.message)
                }
            } else {
                handler(nil, nil, someErrorMessage)
            }
        }
    }
    class func groupInfo(service: APIService, handler: @escaping (_ group: Group?, _ error: String?) -> ()){
        let path = service.path + "/" + "\(service.parameters["groupId"] as! Int)"
        Connection.callServiceWithName(service.method, serviceName: path, parameters: service.parameters) { (response, result) -> Void in
            if response.successful() {
                let webResponse = WebServiceResponse(result: result as! NSDictionary?)
                if webResponse.success{
                    parseGroupInfo(webResponse: webResponse, handler: handler)
                }else {
                    handler(nil, webResponse.message)
                }
            } else {
                handler(nil, someErrorMessage)
            }
        }
    }
    class func updateMembership(service: APIService, handler: @escaping (_ message: String?, _ error: String?) -> ()){
        APIDataSource.commonUpdateService(service: service, handler: handler)
    }
    class func parseGroupInfo(webResponse: WebServiceResponse, handler: @escaping (_ group: Group?, _ error: String?) -> ()){
        let dataDict = webResponse.result as! Dictionary<String, AnyObject>
        if !dataDict.isEmpty {
            guard let data = dataDict["group"] as? [String: AnyObject] else {
                handler(nil, someErrorMessage)
                return
            }
            let group = Group(value: data)

            handler(group, nil)
        }
        else {
            handler(nil, someErrorMessage)
        }
    }
    class func parseGroups(webResponse: WebServiceResponse, handler: @escaping (_ groups: [Group]?, _ page: Paging?, _ error: String?) -> ()){
        let dataDict = webResponse.result as! Dictionary<String, AnyObject>
        if !dataDict.isEmpty {
            var groups = [Group]()
            guard let groupsData = dataDict["groups"] else {
                handler(nil, nil, someErrorMessage)
                return
            }
            guard let groupsArray = groupsData["data"] as? [Any] else {
                handler(nil, nil, someErrorMessage)
                return
            }
            for data in groupsArray{
                let group = Group(value: data)
                groups.append(group)
            }
            let page = Paging(value: dataDict)
            handler(groups, page, nil)
        }
        else {
            handler(nil, nil, someErrorMessage)
        }
    }
    class func parseGroupMembers(webResponse: WebServiceResponse, handler: @escaping (_ groupMembers: [GroupMember]?, _ page: Paging?, _ error: String?) -> ()){
        let dataDict = webResponse.result as! Dictionary<String, AnyObject>
        if !dataDict.isEmpty {
            var members = [GroupMember]()
            guard let groupsData = dataDict["members"] else {
                handler(nil, nil, someErrorMessage)
                return
            }
            guard let groupsArray = groupsData["data"] as? [Any] else {
                handler(nil, nil, someErrorMessage)
                return
            }
            for data in groupsArray{
                let member = GroupMember(value: data)
                members.append(member)
            }
            let page = Paging(value: dataDict)
            handler(members, page, nil)
        }
        else {
            handler(nil, nil, someErrorMessage)
        }
    }
}
