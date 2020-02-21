//
//  Global.swift
//  Tripp
//
//  Created by Monu on 13/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit
//import BWWalkthrough

// ------------------------------------- Placeholder UIImages for App  ---------------------------------------------------------

let userPlaceHolderImage = #imageLiteral(resourceName: "logo") //Add your userImageplaceholder
let inAppNotificationImage =  UIImage(named:"ic_warning")//Error alert icon
let inAppNotificationSuccessImage =  UIImage(named:"ic_Success")//Success alert icon
let backGroundPlaceHolderImage = #imageLiteral(resourceName: "logo") //Add your backGroundPlaceHolderImage
let backGroundPlaceHolderImageListing = #imageLiteral(resourceName: "logo") //Add your backGroundPlaceHolderImage


class Global {
    
    //-- Token used when you want to reset password from deeplinking
    static var resetPasswordToken = ""
    static var screenRect = UIScreen.main.bounds
    static var alreadyAddedRoutes: [Int] = []
    
    class func setLoginRootVC() {
        //Show Loginview of app
        let rootViewController = loginStoryBoard().instantiateInitialViewController()
        appDelegate.window?.rootViewController = rootViewController
    }
    
    class func setOnboardingRootVC() {
        //Show Loginview of app
        let rootViewController = onboardingStoryBoard().instantiateInitialViewController()
        appDelegate.window?.rootViewController = rootViewController
    }
    
    class func showHomeViewIfLogin(_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?){        
        if AppUser.isLoginUser() {
            let rootViewController = homeStoryBoard().instantiateInitialViewController()
            appDelegate.window?.rootViewController = rootViewController
            let navController = appDelegate.window?.rootViewController as! UINavigationController
            let tabBarController = navController.topViewController as! AppTabBarController
            
            if let isLiveTrcking = AppUserDefaults.value(for: .livetrackingOn) as? Bool, isLiveTrcking == true {
                //show live tracking
                tabBarController.selectedIndex = 1
                
            } else{ //Show Loginview of app
                
                if let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String: AnyObject] {
                    if let aps = userInfo["aps"] as? [String: Any], let groupIds = aps["groupData"] as? [Int], groupIds.count > 0 {
                        // LocationFileManager.writeNotificationToFile(aps)
                        tabBarController.groupID = groupIds[0]
                        tabBarController.selectedIndex = 3
                    } else {
                        tabBarController.selectedIndex = 1
                    }
                } else {
                    tabBarController.selectedIndex = 1
                }
            }
        }
    }
    class func showGroupTabWith(_ groupId: Int){
        
        if AppUser.isLoginUser() {
            
            if let isLiveTrcking = AppUserDefaults.value(for: .livetrackingOn) as? Bool, isLiveTrcking == true {
                return
            }
            
            let rootViewController = homeStoryBoard().instantiateInitialViewController()
            appDelegate.window?.rootViewController = rootViewController
            let navController = appDelegate.window?.rootViewController as! UINavigationController
            let tabBarController = navController.topViewController as! AppTabBarController
            
            tabBarController.groupID = groupId
            tabBarController.selectedIndex = 3
            
        }
    }
    class func showMediaViewer(assets:[MediaAsset], selectedIndex:Int, mode:MediaMode = .viewer, onController: UIViewController? = UIApplication.topViewController(), completionHandler: SaveAssetMediaCompletion? = nil){
        let mediaVC = mediaViewerStoryBoard().instantiateInitialViewController() as! MediaViewerViewController
        mediaVC.assets = assets
        mediaVC.selectedItem = selectedIndex
        mediaVC.mediaMode = mode
        mediaVC.saveAssetHandler = completionHandler
        onController?.present(mediaVC, animated: true, completion: nil)
    }
    
}
