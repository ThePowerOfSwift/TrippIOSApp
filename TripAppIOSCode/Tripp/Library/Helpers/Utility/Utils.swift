//
//  Global.swift
//  Tripp
//
//  Copyright © 2017 Appster. All rights reserved.
//

//--------------- This class is used for all Global variables and functions in all projects ---------------------------------------

import Foundation
import UIKit
import NRControls
import Alamofire

//MARK: ------------------------------------------- Variables -------------------------------------------
let appDelegate = UIApplication.shared.delegate as! AppDelegate

//MARK: ------------------------------------------- AppName -------------------------------------------

var applicationName: String {
    let mainBundle = Bundle.main
    let key = String(kCFBundleNameKey)
    let value = mainBundle.object(forInfoDictionaryKey: key) as? String
    return value ?? ""
}
//MARK: ------------------------------------------- Window -------------------------------------------
let windowGlobal = UIApplication.shared.keyWindow

//MARK: -------------------------------------------User Error (use this when you return custom error in NSError)
let userError = NSError(domain: "apperror", code: -1309, userInfo: ["error": "user generated error"])

//MARK: ------------------------------------------- Functions -------------------------------------------
func DLog( message: AnyObject, function: String = #function, line: Int = #line, column: Int = #column) {
    #if DEBUG
        print("\(function): \(message), \(#file), \(line), \(column)")
    #endif

}
//MARK: ------------------------------------------- Global Functions -------------------------------------------

// ------------------------------------------- Alerts -------------------------------------------


// -------------------------------- Tutorial - UserDefaults - Keys-------------------------------



func showTryAgainAlert() {

    AppToast.showErrorMessage(message: tryAgainMessage)
}

func showNoRecordFoundAlert() {

    AppToast.showSuccessMessage(message: noRecordFound)
}

func showNoLocationFoundAlert() {

    AppToast.showErrorMessage(message: noLocationFound)
}

func showNoInternetConnectionAlert() {

    AppToast.showErrorMessage(message: noInternetConnection)
}

func showUnderDevelopmentAlert() {
    AppToast.showErrorMessage(message: underDevelopmentMessage)
}

// ------------------------------------------- Swift Guard -------------------------------------------
func isGuardObject(_ value: Any?) -> Bool {
    guard let _ = value else {
        return false
    }
    return true
}

// ------------------------------------------- Print API Response -----------------------------------
func logAPIResponse(response: DataResponse<Any>){
    if isGuardObject(response.data as AnyObject?) {
        let dataString = String(data: response.data!, encoding: String.Encoding.utf8)
        DLog(message: "Response for  \(String(describing: response.request?.url))/ is  \n \(String(describing: dataString))  \(String(describing: response.response))" as AnyObject)
    }
}

class Utils {

    //MARK: ------------------------------------- Thead Queues -------------------------------------
    class func mainQueue(_ block: @escaping () -> ()) {
        DispatchQueue.main.async { () -> Void in
            block()
        }
    }

    class func createBackGroundQueue(_ block: @escaping () -> ()) {
        let backGroundQueue: DispatchQueue = DispatchQueue(label: "backGroundQueue", attributes: [])

        backGroundQueue.async { () -> Void in
            block()
        }
    }

    class func delay(seconds: Double, completion: @escaping () -> ()) {
        let popTime = DispatchTime.now() + Double(Int64(Double(NSEC_PER_SEC) * seconds)) / Double(NSEC_PER_SEC)

        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }

 
    class func showAlertWithMessage(_ message: String) {
        NRControls.sharedInstance.openAlertViewFromViewController(UIApplication.topViewController()!, message: message, buttonsTitlesArray: [okayButtonTitle], completionHandler: nil)
        
    }
    class func openAlertViewFromViewController(_ viewController: UIViewController, title: String = "", message: String = "", buttonsTitlesAndTypesArray: [(name:String, type: UIAlertActionStyle)], completionHandler: AlertControllerCompletionHandler?){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for element in buttonsTitlesAndTypesArray {
            
            let action:UIAlertAction = UIAlertAction(title: element.name, style: element.type, handler: { (action) -> Void in
                if let _ = completionHandler {
                    completionHandler!(alertController, buttonsTitlesAndTypesArray.index(where: { $0 == element })!)
                }
                
            })
            alertController.addAction(action)
        }
        
        viewController.present(alertController, animated: true, completion: nil)
        
    }
    
    class func uploadImageOnSS3(image : UIImage, type:FileType, completion: @escaping (_ name:String?, _ errorMessage:String?) -> ()){
        AWSImageManager.sharedManger.saveImageToLocalCache(image.compressImage(), folderName: type, saveImageName: nil) { (name, imageC) in
            AWSImageManager.sharedManger.uploadImagetoS3(image: imageC as! UIImage, imageName: name!, type: type, handler: { (success) in
                uploadCompletedWith(success: success, name: name!, completion: completion)
            })
        }
    }
    
    class func uploadVideoOnS3(videoUrl: String, type:FileType, completion: @escaping (_ name:String?, _ errorMessage:String?) -> ()){
        let fileName = AWSImageManager.sharedManger.newFileName(type.rawValue, fileExtension: ".mp4")
        AWSImageManager.sharedManger.uploadVideoToS3(videoUrl: videoUrl, fileName: fileName) { (success) in
            uploadCompletedWith(success: success, name: fileName, completion: completion)
        }
    }
    
    class func uploadProfileImageOnSS3(image : UIImage, completion: @escaping (_ name:String?, _ errorMessage:String?) -> ()){
        self.uploadImageOnSS3(image: image, type: .profile, completion: completion)
    }
    class func uploadGroupImageOnS3(image : UIImage, completion: @escaping (_ name:String?, _ errorMessage:String?) -> ()){
        self.uploadImageOnSS3(image: image, type: .group, completion: completion)
    }
    class func uploadMapImageOnSS3(image : UIImage, completion: @escaping (_ name:String?, _ errorMessage:String?) -> ()){
        self.uploadImageOnSS3(image: image, type: .media, completion: completion)
    }
    
    class func uploadCompletedWith(success: Bool, name: String, completion: @escaping (_ name:String?, _ errorMessage:String?) -> ()){
        Utils.mainQueue {
            if success{
                DLog(message: "Image uploaded with name \(name)" as AnyObject)
                completion(name, nil)
            }else{
                completion(nil, failedToUploadImageOnSS3)
            }
        }
    }
    class func generateError(_ domain: String, code: Int, message: String) -> Error{
       return NSError(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: message]) as Error
        
    }
    class func openSettingsApp(){
        UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
    }

    class func videoURL(fromName: String) -> String{
        return s3BaseURL + ConfigurationManager.shared.s3Bucketname() + "/" + fromName
    }
    
    class func imageUrl(fromName: String) -> String {
        return s3BaseURL + ConfigurationManager.shared.s3Bucketname() + "/" + fromName
    }
    
    class func shareImageOnFacebook(_ image: UIImage?, type: FacebookShareType, trip: Route, controller: UIViewController) {
        guard let screenShot = image else {
            return
        }
        
        // Upload image on S3
        AppLoader.showLoader()
        Utils.uploadMapImageOnSS3(image: screenShot, completion: { (name, error) in
            AppLoader.hideLoader()
            if let imageName = name {
                FacebookManager.shareAppWithImage(Utils.imageUrl(fromName: imageName), link: appShareUrl, trip: trip, type: type, from: controller)
            } else {
                AppToast.showErrorMessage(message: error!)
            }
        })
    }
    
}
