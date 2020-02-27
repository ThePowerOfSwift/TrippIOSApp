//
//  AppTabBarController.swift
//  Tripp
//
//  Created by Bharat Lal on 20/01/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import Foundation
import UIKit
class AppTabBarController: UITabBarController, UITabBarControllerDelegate {
    var groupID: Int? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
         guard let items = tabBar.items else { return }
        let index = items.index(of: item)
        if index == 0 {
            guard let isRouteToolTipShown = AppUserDefaults.value(for: .routeTips) else {
                return
            }
            guard let shown = isRouteToolTipShown as? Bool, shown == false else {
                AdMobVideoManager.shared.presentVideoAd()
                return
            }
        } else if index == 3 {
           // AdMobVideoManager.shared.presentVideoAd()
        }
        
    }
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
       
    }
}
