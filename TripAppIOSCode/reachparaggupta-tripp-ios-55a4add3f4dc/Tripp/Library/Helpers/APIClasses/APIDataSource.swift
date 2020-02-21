//
//  APIDataSource.swift
//  Tripp
//
//  Copyright © 2017 Appster. All rights reserved.


//-------- This class is for all Web services methods used only in this project -------------------------

import Foundation
import Alamofire


typealias APIServiceCompletionHandler = (_ response: DataServiceResponse, _ result: AnyObject?) -> Void

class APIDataSource  {
    
    //MARK: Common service
    class func commonService(service: APIService, handler: @escaping (_ error: String?) -> ()) {
        Connection.callServiceWithName(service.method, serviceName: service.path, parameters: service.parameters) { (response, result) -> Void in
            if response.successful() {
                let webResponse = WebServiceResponse(result: result as! NSDictionary?)
                webResponse.success ?  handler(nil) : handler(webResponse.message)
            } else {
                handler(someErrorMessage)
                //showTryAgainAlert()
            }
        }
    }
    
    /**
     * @method commonUpdateService
     * @discussion Common service used for updating data on server and get only message.
     */
    class func commonUpdateService(service:APIService, handler:@escaping (_ message: String?, _ error: String?) -> ()){
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
    
    /**
     * @method login
     * @discussion User Login API.
     */
    class func login(service: APIService, handler: @escaping (_ user: AppUser?, _ error: String?) -> ()) {
        Connection.callServiceWithName(service.method, serviceName: service.path, parameters: service.parameters) { (response, result) -> Void in
            parseUser(response: response, result: result as? NSDictionary, handler: handler)
        }
    }

    /**
     * @method register
     * @discussion User Regsitration API.
     */
    class func register(service: APIService, handler: @escaping (_ user: AppUser?, _ error: String?) -> ()) {
        Connection.callServiceWithName(service.method, serviceName: service.path, parameters: service.parameters) { (response, result) -> Void in
            parseUser(response: response, result: result as? NSDictionary, handler: handler)
        }
    }
    
    /**
     * @method forgotPassword
     * @discussion Forgot Password API.
     */
    class func forgotPassword(service: APIService, handler: @escaping (_ message: String?, _ error: String?) -> ()) {
        commonUpdateService(service: service, handler: handler)
    }
    
    /**
     * @method forgotPassword
     * @discussion Forgot Password API.
     */
    class func resetPassword(service: APIService, handler: @escaping (_ message: String?, _ error: String?) -> ()) {
        commonUpdateService(service: service, handler: handler)
    }
    
    /**
     * @method changePassword
     * @discussion Change Password API.
     */
    class func changePassword(service: APIService, handler: @escaping (_ message: String?, _ error: String?) -> ()) {
        APIDataSource.commonUpdateService(service: service, handler: handler)
    }
    
    /**
     * @method sendFeedback
     * @discussion Send Feedback API.
     */
    class func sendFeedback(service: APIService, handler: @escaping (_ message: String?, _ error: String?) -> ()) {
        commonUpdateService(service: service, handler: handler)
    }
    
    /**
     * @method logout
     * @discussion Logout User API.
     */
    class func verifyPassword(service: APIService, handler: @escaping (_ message: String?, _ error: String?) -> ()) {
        commonUpdateService(service: service, handler: handler)
    }
    
    /**
     * @method updateUserMemberShip
     * @discussion Logout User API.
     */
    class func updateUserMemberShip(service: APIService, handler: @escaping (_ message: String?, _ error: String?) -> ()) {
        commonUpdateService(service: service, handler: handler)
    }
    
    /**
     * @method logout
     * @discussion Logout User API.
     */
    class func logout(handler: @escaping (_ message: String?, _ error: String?) -> ()) {
        commonUpdateService(service: .logout, handler: handler)
    }
    
    /**
     * @method addToMyTrip
     * @discussion Add route into my trip list.
     */
    class func addToMyTrip(service: APIService, handler: @escaping (_ message: String?, _ error: String?) -> ()){
        commonUpdateService(service: service, handler: handler)
    }
    
    /**
     * @method addLocationToWistList
     * @discussion Add location to wish list API.
     */
    class func addLocationToWistList(service: APIService, handler: @escaping (_ message: String?, _ error: String?) -> ()){
        commonUpdateService(service: service, handler: handler)
    }
    /**
     * @method removeLocationFromWistList
     * @discussion remove a location from wish list.
     */
    class func removeLocationFromWistList(service: APIService, handler: @escaping (_ message: String?, _ error: String?) -> ()){
        commonUpdateService(service: service, handler: handler)
    }
    class func completeWish(service: APIService, handler: @escaping (_ message: String?, _ error: String?) -> ()){
        commonUpdateService(service: service, handler: handler)
    }
    /**
     * @method updateDeviceToken
     * @discussion Update device token for push notification.
     */
    class func updateDeviceToken(){
        if AppUser.isLoginUser() && !AppSharedClass.shared.deviceToken.isEmpty {
            let service: APIService = .updateDeviceToken(deviceToken: AppSharedClass.shared.deviceToken)
            commonService(service: service) { (message) in
                DLog(message: "Device Token Updated" as AnyObject)
            }
        }
    }
    
    /**
     * @method forgotPassword
     * @discussion Forgot Password API.
     */
    class func updateProfile(service: APIService, handler: @escaping (_ user: AppUser?, _ error: String?) -> ()) {
        Connection.callServiceWithName(service.method, serviceName: service.path, parameters: service.parameters) { (response, result) -> Void in
            if response.successful() {
                let webResponse = WebServiceResponse(result: result as! NSDictionary?)                
                if webResponse.success{
                    parseUpdateUser(webResponse: webResponse, handler: handler)
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
     * @method fetchStates
     * @discussion Fetch states.
     */
    class func fetchStates(handler: ((_ stateList: [State]?, _ error: String?) -> ())?) {
        if AppUser.isLoginUser(){
            State.clearStates()
            let service: APIService = .states
            Connection.callServiceWithName(service.method, serviceName: service.path, parameters: service.parameters) { (response, result) -> Void in
                if response.successful() {
                    let webResponse = WebServiceResponse(result: result as! NSDictionary?)
                    if webResponse.success{
                        parseStates(webResponse: webResponse, handler: handler)
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
    /**
     * @method userWishList
     * @discussion Fetch user wish list.
     */
    class func userWishList(service: APIService, handler: @escaping (_ wishList: [WishList]?, _ error: String?) -> ()) {
        Connection.callServiceWithName(service.method, serviceName: service.path, parameters: service.parameters) { (response, result) -> Void in
            if response.successful() {
                let webResponse = WebServiceResponse(result: result as! NSDictionary?)
                if webResponse.success{
                    parseWishList(webResponse: webResponse, handler: handler)
                }else {
                    handler(nil, webResponse.message)
                }
            } else {
                handler(nil, someErrorMessage)
               // showTryAgainAlert()
            }
        }
    }
    class func userLocationWishList(service: APIService, handler: @escaping (_ wishList: [LocationWish]?, _ error: String?) -> ()) {
        Connection.callServiceWithName(service.method, serviceName: service.path, parameters: service.parameters) { (response, result) -> Void in
            if response.successful() {
                let webResponse = WebServiceResponse(result: result as! NSDictionary?)
                if webResponse.success{
                    parseLocationWishList(webResponse: webResponse, handler: handler)
                }else {
                    handler(nil, webResponse.message)
                }
            } else {
                handler(nil, someErrorMessage)
                //showTryAgainAlert()
            }
        }
    }
    class func userStatistic(service: APIService, handler: @escaping (_ user: AppUser?, _ error: String?) -> ()) {
        updateProfile(service: service, handler: handler)
    }
    /**
     * @method fetchRoutes
     * @discussion Fetch admin routes.
     */
    class func fetchRoutes(_ service: APIService, handler: @escaping (_ routes: [Route]?, _ totalPage: Int?, _ perPageCount: Int?, _ error: String?) -> ()){
        Connection.callServiceWithName(service.method, serviceName: service.path, parameters: service.parameters, isInterNetCheck: false) { (response, result) in
            if response.successful() {
                let webResponse = WebServiceResponse(result: result as! NSDictionary?)
                if webResponse.success{
                    parseRoutes(webResponse: webResponse, handler: handler)
                }else {
                    handler(nil, 0, 0, webResponse.message)
                }
            } else {
                handler(nil, 0, 0, someErrorMessage)
               // showTryAgainAlert()
            }
        }
    }
    class func fetchNotifications(handler: @escaping ((_ notifications: [UserNotification]?, _ error: String?) -> ())) {
            let service: APIService = .userNotification
            Connection.callServiceWithName(service.method, serviceName: service.path, parameters: service.parameters) { (response, result) -> Void in
                if response.successful() {
                    let webResponse = WebServiceResponse(result: result as! NSDictionary?)
                    if webResponse.success{
                        parseNotifications(webResponse: webResponse, handler: handler)
                    }else {
                        handler(nil, webResponse.message)
                        
                    }
                } else {
                    handler(nil, someErrorMessage)
                }
            }
    }

}
