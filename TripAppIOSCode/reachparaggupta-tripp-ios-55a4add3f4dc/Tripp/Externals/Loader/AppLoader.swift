//
//  AppLoader.swift
//  Tripp
//
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

class AppLoader {

    class func setConfig() {
        var config: SwiftLoader.Config = SwiftLoader.Config()
        config.size = 100
        config.backgroundColor = UIColor.white
        let appTheamColor = UIColor(red: 48.0 / 255.0, green: 160 / 255, blue: 254.0 / 255.0, alpha: 1)
        config.spinnerColor = appTheamColor
        config.titleTextColor = UIColor.red
        config.spinnerLineWidth = 2.0
        config.foregroundColor = UIColor.black
        config.foregroundAlpha = 0.5

        SwiftLoader.setConfig(config)

    }

    class func showLoader() {

        SwiftLoader.hide()
        UIApplication.shared.endIgnoringInteractionEvents()

        UIApplication.shared.beginIgnoringInteractionEvents()
        Utils.delay(seconds: 0.2) { () -> () in
            AppLoader.setConfig()
            SwiftLoader.show(animated: true)
        }
    }

    class func hideLoader() {

        UIApplication.shared.endIgnoringInteractionEvents()

        Utils.delay(seconds: 0.2) { () -> () in
            SwiftLoader.hide()
        }
    }

    class func showLoaderWithoutBlockUI() {

        Utils.delay(seconds: 0.2) { () -> () in
            AppLoader.setConfig()

            SwiftLoader.show(animated: true)
        }
    }

}
