//
//  AppDelegate+CustomAppearance.swift
//  Tripp
//
//  Created by Bharat Lal on 20/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

extension AppDelegate{
    class func tabBarFont(){
        
        let titleFontAll : UIFont = UIFont.sfuiTextRegular(size: 12.0)
        
        let attributesNormal = [
            NSAttributedStringKey.font : titleFontAll,
            NSAttributedStringKey.foregroundColor : UIColor.tabbarFontColor()
        ]
        
        let attributesSelected = [
            NSAttributedStringKey.font : titleFontAll,
            NSAttributedStringKey.foregroundColor : UIColor.tabbarSelectedFontColor()
        ]
        
        UITabBarItem.appearance().setTitleTextAttributes(attributesNormal, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributesSelected, for: .selected)
    }
}
