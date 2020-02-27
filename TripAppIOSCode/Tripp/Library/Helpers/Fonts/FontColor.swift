//
//  FontColor.swift
//  Tripp
//
//  Copyright © 2017 Appster. All rights reserved.
//

//-------- This class is for all Font Colors methods used only in this project -------------------------

import Foundation
import UIKit

class FontColor {

    // ------------------------------------- Theme Colors  ---------------------------------------------------------
    class func themeColor() -> UIColor {
        return UIColor(red: 73.0 / 255, green: 111.0 / 255, blue: 171.0 / 255, alpha: 1.0)
    }

    class func buttonBackgroundColor() -> UIColor {
        return UIColor(red: 149.0 / 255, green: 46.0 / 255, blue: 62.0 / 255, alpha: 1.0)
    }

    class func buttonHiglightBackGroungColor() -> UIColor {
        return UIColor(red: 100.0 / 255, green: 50.0 / 255, blue: 68.0 / 255, alpha: 1.0)
    }

    class func selectionBackGroungColor() -> CGColor {
        return UIColor(red: 242 / 255, green: 64 / 255, blue: 101 / 255, alpha: 1.0).cgColor

    }
    
}
