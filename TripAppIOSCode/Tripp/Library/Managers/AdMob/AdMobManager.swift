//
//  AdMobManager.swift
//  Tripp
//
//  Created by Monu on 18/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import GoogleMobileAds

let adMobServiceAppId =  "ca-app-pub-3723560518322658~6435115528"

struct AdUnitId {
    static let banner = "ca-app-pub-3723560518322658/8592066076"
    static let inline = "ca-app-pub-3723560518322658/9448339408"
    static let video = "ca-app-pub-3723560518322658/3148167701"
}

class AdMobManager: NSObject, GADBannerViewDelegate {
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error)
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print(bannerView)
    }
    
    static let shared = AdMobManager()
    
    class func initializeAdMob(){
        //GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.configure(withApplicationID: adMobServiceAppId)
        AdMobVideoManager.shared.loadVideo()
    }
    
    class func loadBanner(_ bannerView: GADBannerView, rootViewController: UIViewController){
        if AppUser.currentUser().subscription() != .subscribed {
            bannerView.adUnitID = AdUnitId.banner
            bannerView.delegate = AdMobManager.shared
            bannerView.rootViewController = rootViewController
            bannerView.load(AdMobVideoManager.shared.request())
        } else {
            guard let constraint = (bannerView.constraints.filter{$0.firstAttribute == .height}.filter({$0.identifier == "bannerHeight"})).first else { return }
            constraint.constant = 0.0
            bannerView.isHidden = true
        }
    }
    
    class func loadInlineBanner(_ bannerView: GADBannerView){
        if AppUser.currentUser().subscription() != .subscribed {
            bannerView.adUnitID = AdUnitId.banner
            bannerView.rootViewController = UIApplication.topViewController()
            bannerView.load(AdMobVideoManager.shared.request())
        }
    }
    
    class func checkAndUpdateBanner(_ bannerView: GADBannerView) {
        guard let constraint = (bannerView.constraints.filter{$0.firstAttribute == .height}.filter({$0.identifier == "bannerHeight"})).first else { return }
        if AppUser.currentUser().subscription() == .subscribed {
            constraint.constant = 0.0
            bannerView.isHidden = true
        } else {
            constraint.constant = 50.0
            bannerView.isHidden = false
        }
    }
    
}
