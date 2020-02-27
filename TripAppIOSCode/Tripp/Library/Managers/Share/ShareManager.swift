//
//  ShareManager.swift
//  Tripp
//
//  Created by Monu on 04/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit


class ShareManager {
    
    class func shareAppActionSheet(onController: UIViewController, handler: @escaping (_ isCancel: Bool, _ isFacebook: Bool) -> Void ) {
        let alertController = UIAlertController(title: nil, message: shareApp, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cancelAction = UIAlertAction(title: cancel, style: .cancel) { (camera) -> Void in
            handler(true, false)
        }
        
        let facebook = UIAlertAction(title: facebookShare, style: .default) { (camera) -> Void in
           handler(false, true)
        }
        
        let other = UIAlertAction(title: shareOnOther, style: .default) { (camera) -> Void in
            handler(false, false)
        }
        
        alertController.addAction(facebook)
        alertController.addAction(other)
        alertController.addAction(cancelAction)
        onController.present(alertController, animated: true, completion: nil)
    }
    
    class func share(shareItems: Array<Any>) {
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo, UIActivityType.addToReadingList, UIActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"),UIActivityType(rawValue: "com.apple.mobilenotes.SharingExtension"),UIActivityType.assignToContact]
        UIApplication.topViewController()?.present(activityViewController, animated: true, completion: nil)
    }
    
    class func openLocationAlertAction(onController: UIViewController){
        let alertController = UIAlertController(title: nil, message: chooseOption, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cancelAction = UIAlertAction(title: cancel, style: .cancel, handler: nil)
        onController.present(alertController, animated: true, completion: nil)
        
        let openMap = UIAlertAction(title: "Open in Map", style: .default) { (camera) -> Void in
            DLog(message: "Open MAP" as AnyObject)
        }
        
        let addToWishList = UIAlertAction(title: "Add to wish list", style: .default) { (camera) -> Void in
            DLog(message: "Add to wish list" as AnyObject)
        }
        
        alertController.addAction(openMap)
        alertController.addAction(addToWishList)
        alertController.addAction(cancelAction)
    }
}
