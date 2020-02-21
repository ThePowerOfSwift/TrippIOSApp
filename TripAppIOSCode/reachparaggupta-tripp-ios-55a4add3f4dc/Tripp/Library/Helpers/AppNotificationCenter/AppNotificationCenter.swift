//
//  AppNotificationCenter.swift
//  Tripp
//
//  Created by Monu on 09/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

class AppNotificationCenter {
    
    class func post(notification: NSNotification.Name, withObject info: [String:Any]?){
        if Thread.isMainThread {
            NotificationCenter.default.post(name: notification, object: nil, userInfo: info)
        } else {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: notification, object: nil, userInfo: info)
            }
        }
    }
    
}

struct AppNotification {
    static let mediaDeleted = NSNotification.Name(mediaDeletedAppNotification)
    static let popTipHide = NSNotification.Name(popTipHideAppNotification)
    static let updateTrip = NSNotification.Name(updateTripNotification)
    static let deleteRouteWish = NSNotification.Name(deleteWishNotification)
    static let gotoMyTrip = NSNotification.Name(gotoMyTripNotification)
    static let deleteMyTrip = NSNotification.Name(deleteMyTripNotification)
    static let deleteLocationWish = NSNotification.Name(deleteLocationWishNotification)
    static let completeLocationWish = NSNotification.Name(completeLocationWishNotification)
    static let shareMyTrip = NSNotification.Name(shareMytripNotification)
    static let liveTripFinished = NSNotification.Name(liveTripFinishNotification)
    static let userClosedVideoAd = NSNotification.Name(videoAdClosedNotification)
    static let textFieldRightViewTapped = NSNotification.Name(textFieldRightViewNotification)
}


let mediaDeletedAppNotification = "mediaDeletedAppNotification"
let popTipHideAppNotification = "popTipHideAppNotification"
let notificationPopTypeKey = "popType"
let updateTripNotification = "updateTripNotification"
let deleteWishNotification = "deleteWishNotification"
let gotoMyTripNotification = "gotoMyTripNotification"
let deleteMyTripNotification = "deleteMyTrip"
let deleteLocationWishNotification = "deleteLocationWish"
let completeLocationWishNotification = "completeLocationWish"
let shareMytripNotification = "shareMyTrip"
let liveTripFinishNotification = "liveTripFinishNotification"
let videoAdClosedNotification = "videoAdClosedNotification"
let textFieldRightViewNotification = "textFieldRightViewNotification"
