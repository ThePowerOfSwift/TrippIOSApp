//
//  FacebookManager.swift
//  Tripp
//
//  Created by Monu on 26/02/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import Foundation
import FBSDKShareKit
import FBSDKLoginKit

enum FacebookShareType {
    case walk
    case run
    case bike
    
    var action: String {
        switch self {
        case .walk:
            return "fitness.walks"
        case .run:
            return "fitness.runs"
        case .bike:
            return "fitness.bikes"
        }
    }
    
}

class FacebookManager {
    
    class func shareAppWithImage(_ image: String, link: String, trip: Route, type: FacebookShareType, from: UIViewController) {
        shareOnFacebook(image, link: link, trip: trip, type: type, from: from)
//        if FBSDKAccessToken.current() == nil {
//            facebookLogin(controller: from, completion: { (status, error) in
//                if status == true {
//                    shareOnFacebook(image, link: link, trip: trip, type: type, from: from)
//                }
//            })
//        } else {
//            shareOnFacebook(image, link: link, trip: trip, type: type, from: from)
//        }
    }
    
    class func shareOnFacebook(_ image: String, link: String, trip: Route, type: FacebookShareType, from: UIViewController) {
        let linkString = "https://www.atlasmediadev.com/share-tripp?image=\(image)&trip_id=" + trip.tripId.description
        let params: [AnyHashable: Any] = [
            "og:type": "fitness.course",
            "og:url" : linkString
        ]
        
        // Create an action
        let object = FBSDKShareOpenGraphObject(properties: params)
        let action = FBSDKShareOpenGraphAction()
        action.actionType = "fitness.runs"
        action.setObject(object, forKey: "fitness:course")
        
        // Create the content
        let content = FBSDKShareOpenGraphContent()
        content.action = action
        content.previewPropertyName = "fitness:course"
        
        let shareDialog = FBSDKShareDialog()
        shareDialog.fromViewController = from
        shareDialog.shareContent = content
        if shareDialog.canShow() {
            shareDialog.show()
        }
    }
    
    class func facebookLogin(controller: UIViewController, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        FBSDKLoginManager().logIn(withPublishPermissions: ["publish_actions"], from: controller) { (result, error) in
            if error == nil {
                if (result?.isCancelled)! {
                    let err = NSError(domain: "502", code: 501, userInfo: [NSLocalizedDescriptionKey: ""])
                    completion(false, err)
                } else {
                    completion(true, nil)
                }
            }
        }
    }
    
}
