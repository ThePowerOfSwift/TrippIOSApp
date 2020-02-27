//
//  Connection.swift
//  Tripp
//
//  Copyright © 2017 Appster. All rights reserved.
//

//---------------- This class is used as Network Layer in the the app ---------------------------------------

import Foundation
import Alamofire
import Reachability

let SUCCESS_CODE = 200
let UNAUTHORIZED = 401
typealias NRCompletionHander = (_ response: DataServiceResponse, _ result: AnyObject?) -> Void


class Connection {

    class func isInternetAvailable() -> Bool {
        
        do {
            let internetReach = Reachability(hostname: "google.com")
            internetReach?.stopNotifier()
            try internetReach?.startNotifier()
            return internetReach!.isReachable
        }
            
        catch (_) {
            //DLOG(Error)
        }
        
        return false
    }
    class func isInternetConnected(_ savingOffline: Bool = false) -> Bool{
        if !Connection.isInternetAvailable() {
            AppLoader.hideLoader()
            Utils.mainQueue({ () -> () in
                if savingOffline {
                    AppToast.showSuccessMessage(message: saveOfflineWhenNoInternet)
                } else {
                    
                    AppToast.showErrorMessage(message: internetConectionError)
                }
                
            })
            return false
        }
        return true
    }
    
    class func callServiceWithName(_ methodType: HTTPMethod, serviceName: String, parameters: Dictionary<String, Any>, isInterNetCheck:Bool, completionHandler: @escaping NRCompletionHander) {
        
        if isInterNetCheck && !isInternetConnected() {
            return
        }
        
        let params = parameters
        var headers = ["X-Tripp-Api-Version": "v1"]
        if AppUser.isLoginUser() {
            headers ["userToken"] = AppUser.currentUser().userToken
            headers ["deviceId"] = AppUser.currentUser().deviceId
            
        }else{
            headers ["deviceId"] = Devices.deviceIdentifier
        }
        
        var encoding: ParameterEncoding = JSONEncoding.default
        if methodType == .get {
            encoding = URLEncoding.default
        }
        
        let baseUrl = ConfigurationManager.shared.appBaseURL() + "\(serviceName)"
        DLog(message: "Request for \(baseUrl)/ Parameters \n \(params)" as AnyObject)
        DLog(message: "Request headers \(headers)" as AnyObject)
        Alamofire.request(baseUrl, method: methodType, parameters: params, encoding: encoding, headers: headers).responseJSON { response in
            parseAPIResponse(response: response, completionHandler: completionHandler)
        }
    }
    
    class func callServiceWithName(_ methodType: HTTPMethod, serviceName: String, parameters: Dictionary<String, Any>, completionHandler: @escaping NRCompletionHander) {

        callServiceWithName(methodType, serviceName: serviceName, parameters: parameters, isInterNetCheck: true, completionHandler: completionHandler)
    }
    
    class func parseAPIResponse(response: DataResponse<Any>, completionHandler: @escaping NRCompletionHander){
        logAPIResponse(response: response)
        switch response.result {
        case .success:
            let statusCode = response.response?.statusCode
            if isUnauthorizedRequest(statusCode: statusCode!){
                return
            }
            (statusCode == SUCCESS_CODE) ? requestSuccess(response: response, completionHandler: completionHandler) : completionHandler(.error(""), nil)
        case let .failure(error):
            DLog(message: error as AnyObject)
            if (error as NSError).code != -999 { // -999 means request has been cancelled
                completionHandler(.error(""), nil)
            }else{
                completionHandler(.error("cancelled"),nil)
            }
            
        }
    }
    
    class func isUnauthorizedRequest(statusCode: Int) -> Bool{
        if statusCode == UNAUTHORIZED && AppUser.isLoginUser(){
            AppLoader.hideLoader()
            AppToast.showErrorMessage(message: unauthorizedAccessMessage)
            if LiveTrackingManager.sharedManager.isStarted {
                LiveTrackingManager.sharedManager.exit()
            }
            AppUser.deleteUser()
            Global.setLoginRootVC()
            return true
        }
        return false
    }
    class func requestSuccess(response: DataResponse<Any>, completionHandler: @escaping NRCompletionHander){
        if isGuardObject(response.result.value as AnyObject?) {
            completionHandler(.success, response.result.value! as AnyObject?)
        } else {
            completionHandler(.error(""), nil)
        }
    }
    class func callServiceWithImagesArray(_ methodType: HTTPMethod, imagesArray: [UIImage], videosArray: [Data] = [], parameters: Dictionary<String, Any>, serviceName: String, completionHandler: @escaping NRCompletionHander) {

        if !Connection.isInternetAvailable() {
            AppLoader.hideLoader()
            Utils.mainQueue({ () -> () in
                AppToast.showErrorMessage(message: internetConectionError)
            })
            completionHandler(.error(""), nil)
            return
        }
        
        let params = parameters
        var headers = ["X-Tripp-Api-Version": "v1"]
        if AppUser.isLoginUser() {
            headers ["X-Tripp-Authorization"] = AppUser.currentUser().userToken
        }
        let baseUrl = ConfigurationManager.shared.appBaseURL() + "\(serviceName)"

        DLog(message: "Request for \(baseUrl)/\(serviceName) Parameters \n \(params)" as AnyObject)
        
        Alamofire.upload(multipartFormData: appendMedia(params: params, imagesArray: imagesArray, videosArray:videosArray),
                         to: baseUrl) { (encodingResult) in
            switch encodingResult {
                
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    logAPIResponse(response: response)
                    isGuardObject(response.result.value as AnyObject?) ? completionHandler(.success, response.result.value! as AnyObject?) : completionHandler(.error(""), nil)
                }
            case .failure( _):
                completionHandler(.error(""), nil)
                
            }
        }

    }
    class func appendMedia(params:[String:Any], imagesArray: [UIImage], videosArray: [Data] = []) -> ((MultipartFormData) -> Void){
        let handler:((MultipartFormData) -> Void) = { (multipartFormData) in
            for i in 0 ..< imagesArray.count {
                let fileName = "image\(i + 1).jpg"
                let imageName = "image\(i + 1)"
                multipartFormData.append(UIImageJPEGRepresentation(imagesArray[i], 0.8)!, withName: imageName, fileName: fileName, mimeType: "image/jpeg")
                
            }
            
            for i in 0..<videosArray.count // upload images with imagename (image1 , image2 .....)
            {
                let fileName = "video\(i+1).mp4"
                let videoName = "video\(i+1)"
                multipartFormData.append(videosArray[i], withName: videoName, fileName: fileName, mimeType: "video/mp4")
                
            }
            
            do {
                for (key, value) in params {
                    let keyTemp = String(key)
                    let valueTemp = String(describing: value)
                    let valeData = valueTemp.data(using: String.Encoding.utf8)
                    multipartFormData.append(valeData!, withName: keyTemp)
                    
                }
            }
        }
        return handler
    }

    class func callServiceWithURL(_ url: URL, completionHandler: @escaping NRCompletionHander) {

        if !Connection.isInternetAvailable() {
            AppLoader.hideLoader()
            Utils.mainQueue({ () -> () in
                AppToast.showErrorMessage(message: internetConectionError)
            })
            completionHandler(.error(""), nil)
            return
        }
        
        Alamofire.request(url).responseJSON { response in
            DLog(message: response.debugDescription as AnyObject)
            
            switch response.result {
            case .success:
                if isGuardObject(response.result.value as AnyObject?) {
                    completionHandler(.success, response.result.value! as AnyObject?)
                    
                } else {
                    completionHandler(.error(""), nil)
                    
                }
                DLog(message: "success" as AnyObject)
            case .failure( _):
                completionHandler(.error(""), nil)
                
            }
        }
        
    }
    
   
}
