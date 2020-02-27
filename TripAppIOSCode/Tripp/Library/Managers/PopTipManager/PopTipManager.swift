//
//  PopTipManager.swift
//  Pods
//
//  Created by Bharat Lal on 09/08/17.
//
//

import Foundation
import  AMPopTip
import UIKit
class PopTipManager  {
    class func popTip() -> PopTip{
        let popTip = PopTip()
        popTip.padding = 0.0
        popTip.cornerRadius = 12
        popTip.borderWidth = 0.0
        popTip.edgeMargin = 12.0
        popTip.bubbleColor = UIColor.white
        popTip.arrowSize = CGSize(width: 28, height: 19)
        popTip.shouldDismissOnTap = false
        popTip.shouldDismissOnTapOutside = false
        popTip.shouldDismissOnSwipeOutside = false
        return popTip
    }
    class func showTipWith(popType: PopTipType, inView: UIView, from: CGRect){
        let popTip = self.popTip()
        let customView = CommonTipView.fromNib()
        let backgroundView = self.bacgroundView()
        customView.initialize(message: popType.message, boldTexts: popType.boldTexts, imageName: popType.imageName){
            popTip.hide()
            backgroundView.removeFromSuperview()
            AppNotificationCenter.post(notification: AppNotification.popTipHide, withObject: [notificationPopTypeKey: popType])
        }
        if popType == .finishRoute{
            AppUserDefaults.set(value: true, for: .tripTips)
        }
        if popType == .waypointSearch{
            popTip.show(customView: customView, direction: .down, in: windowGlobal != nil ? windowGlobal! : inView, from: from)
        }else{
            popTip.show(customView: customView, direction: .up, in: windowGlobal != nil ? windowGlobal! : inView, from: from)
        }
        popTip.addShadowAndCornerRadius(radius: 0, opacity: 0.2)
    }
    class func bacgroundView() -> UIView{
        let backgroundView = UIView(frame: Global.screenRect)
        backgroundView.backgroundColor = UIColor.appBlueColor(withAlpha: 0.38)
        
        windowGlobal?.addSubview(backgroundView)
        return backgroundView
    }
    class func showWayPointCardTip(inView: UIView, from: CGRect){
        let popTip = self.popTip()
        let customView = TripWaypointCardTipView.fromNib()
        let backgroundView = self.bacgroundView()
        customView.initialize(){
            popTip.hide()
             backgroundView.removeFromSuperview()
            AppUserDefaults.set(value: true, for: .tripWaypoitTip)
        }
        popTip.show(customView: customView, direction: .up, in: windowGlobal != nil ? windowGlobal! : inView, from: from)
        popTip.addShadowAndCornerRadius(radius: 0, opacity: 0.2)
    }
}

public enum PopTipType {
    
    case routeTap
    case filter
    case waypointSearch
    case addWaypoint
    case savePoint
    case viewSavedPoints
    case finishRoute
    
    var message: String {
        switch self {
        case .routeTap:
            return"Tap on any route on the map for details"
        case .filter:
            return "Tap the filter button to select the route type and level"
        case .waypointSearch:
            return "Also use the search option to find and create multiple Points"
        case .addWaypoint:
            return "Tap and hold on any location on the map to create multiple points"
        case .savePoint:
            return "Tap save point button to start saving your point locations"
        case .viewSavedPoints:
            return "Slide the card up to see your saved points"
        case .finishRoute:
            return "Use the finish route button to complete your route"
            
        }
    }
    var boldTexts: [String]{
        switch self {
        case .routeTap:
            return ["route on the map"]
        case .filter:
            return ["the filter"]
        case .waypointSearch:
            return ["search option"]
        case .addWaypoint:
            return ["create multiple points"]
        case .savePoint:
            return ["save point"]
        case .viewSavedPoints:
            return ["saved points"]
        case .finishRoute:
            return ["finish route"]
            
        }
    }
    var imageName: String{
        switch self {
            
        case .routeTap:
            return"IcRouteTapTip"
        case .filter, .savePoint, .viewSavedPoints, .finishRoute:
            return "IcButtonTapTip"
        case .waypointSearch:
            return "IcTripSearchTip"
        case .addWaypoint:
            return"IcTripAddWaypointTip"
        
            
        }
    }
}
