//
//  UIFont+AppDefines.swift
//  Tripp
//
//  Created by Bharat Lal on 13/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIFont Extension
extension UIFont {
    
    class func openSensBold(size:CGFloat) -> UIFont{
        return UIFont.init(name: AppFontOpenSens.bold, size: size)!
    }
    
    class func openSensRegular(size:CGFloat) -> UIFont{
        return UIFont.init(name: AppFontOpenSens.regular, size: size)!
    }
    
    class func openSensSemiBold(size:CGFloat) -> UIFont{
        return UIFont.init(name: AppFontOpenSens.semibold, size: size)!
    }
    
    class func openSensLight(size:CGFloat) -> UIFont{
        return UIFont.init(name: AppFontOpenSens.light, size: size)!
    }
    
    class func sfuiTextRegular(size:CGFloat) -> UIFont {
        return UIFont.init(name: AppSFUIText.fontSFUITextRegular, size: size)!
    }
}

struct AppFontOpenSens {

    static let bold: String! = "OpenSans-Bold"
    static let boldItalic: String! = "OpenSans-BoldItalic"
    static let extraBold: String! = "OpenSans-Extrabold"
    static let extraBoldItalic: String! = "OpenSans-ExtraboldItalic"
    static let italic: String! = "OpenSans-Italic"
    static let light: String! = "OpenSans-Light"
    static let lightItalic: String! = "OpenSansLight-Italic"
    static let regular: String! = "OpenSans"
    static let semibold: String! = "OpenSans-Semibold"
    static let semiboldItalic: String! = "OpenSans-SemiboldItalic"
}

struct AppSFUIText{
    static let fontSFUITextRegular = "SFUIText-Regular"
}

