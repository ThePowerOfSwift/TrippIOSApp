//
//  Facebook+Event.swift
//  Tripp
//
//  Created by Monu on 29/12/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import Foundation
import FBSDKCoreKit

extension FacebookManager {
    
    class func initialize() {
        FBSDKSettings.setAutoLogAppEventsEnabled(true)
    }
    
    class func logRatingEvent(contentId : String) {
        let params : [String: Any] = [
            FBSDKAppEventParameterNameContentID : contentId,
            FBSDKAppEventParameterNameMaxRatingValue : 5
        ]
        FBSDKAppEvents.logEvent(FBSDKAppEventNameRated, parameters: params)
    }
    
    class func logCompletedRegistrationEvent() {
        let params : [String: Any] = [FBSDKAppEventParameterNameRegistrationMethod : "Sign Up"]
        FBSDKAppEvents.logEvent(FBSDKAppEventNameCompletedRegistration, parameters: params)
    }
    
}
