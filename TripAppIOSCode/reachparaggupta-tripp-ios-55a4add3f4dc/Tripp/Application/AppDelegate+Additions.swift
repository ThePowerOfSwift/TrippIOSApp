//
//  AppDelegate+Additions.swift
//  Tripp
//
//  Created by Monu on 19/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit

extension AppDelegate{
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            
            if DeepLinking.parse(url: url) == true { return true }
            
            guard let sourceApp = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String else {
                return false
            }
            
            let shouldOpen: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApp, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
            return shouldOpen
    }
    
    // for iOS below 9.0
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return DeepLinking.parse(url: url)
    }
    
    func fetchStateList(){
        self.perform(#selector(AppDelegate.fetchStates), with: nil, afterDelay: 5.0)
        
    }
    @objc func fetchStates(){
        
        APIDataSource.fetchStates(handler: nil)
    }
    
}
