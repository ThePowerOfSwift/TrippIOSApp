//
//  UIApplication+Extension.swift
//  Tripp
//
//  Created by Ankur Arya on 26/02/16.
//  Copyright © 2016 Tripp. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {

    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }

        return base
    }

    class func navigationController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UINavigationController? {

        if let nav = base as? UINavigationController {
            return nav
        }
        if let nav = base?.navigationController {
            return nav
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return navigationController(selected)
        }
        return nil
    }

}
