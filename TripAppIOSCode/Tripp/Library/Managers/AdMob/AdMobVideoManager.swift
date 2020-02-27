
//
//  AdMobVideoManager.swift
//  Tripp
//
//  Created by Monu on 21/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
//import AdSupport

class AdMobVideoManager: NSObject {
    
    static var shared = AdMobVideoManager()
    var isAutoPlay = false
    
    override init() {
        super.init()
        GADRewardBasedVideoAd.sharedInstance().delegate = self
    }
    
    //MARK: - Load Video
    @objc func loadVideo(){
        if AppUser.currentUser().subscription() != .subscribed {
            GADRewardBasedVideoAd.sharedInstance().load(self.request(), withAdUnitID: AdUnitId.video)
        }
    }
    
    func presentVideoAd(){
        if AppUser.currentUser().subscription() != .subscribed {
            if GADRewardBasedVideoAd.sharedInstance().isReady {
                GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: UIApplication.topViewController()!)
            }
            else{
                self.loadVideo()
                self.isAutoPlay = true
            }
        }
    }
    
    func request() -> GADRequest{
        let adRequest = GADRequest()
        return adRequest
    }
}

extension AdMobVideoManager: GADRewardBasedVideoAdDelegate {
    
    // MARK: GADRewardBasedVideoAdDelegate implementation
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error) {
        DLog(message: "Reward based video ad failed to load: \(error.localizedDescription)" as AnyObject)
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        DLog(message: "Reward based video ad is received." as AnyObject)
        if self.isAutoPlay, AppUser.currentUser().subscription() != .subscribed {
            self.isAutoPlay = false
            self.presentVideoAd()
        }
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        DLog(message: "Opened reward based video ad." as AnyObject)
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        DLog(message: "Reward based video ad started playing." as AnyObject)
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        DLog(message: "Reward based video ad is closed." as AnyObject)
        AppNotificationCenter.post(notification: AppNotification.userClosedVideoAd, withObject: nil)
        self.loadVideoWithDelay()
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        DLog(message: "Reward based video ad will leave application." as AnyObject)
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        DLog(message: "Reward received with currency: \(reward.type), amount \(reward.amount)." as AnyObject)
        self.loadVideoWithDelay()
    }
    
    func loadVideoWithDelay(){
        self.perform(#selector(AdMobVideoManager.loadVideo), with: nil, afterDelay: 1.0)
    }
}
