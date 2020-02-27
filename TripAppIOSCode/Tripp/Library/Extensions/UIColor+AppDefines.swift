//
//  UIColor+AppDefines.swift
//  Tripp
//
//  Created by Bharat Lal on 13/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    // MARK: Color with RGBA
    /* Description : Returns color from the combination of RGB color values */
    
    class func colorWith(_ red: CGFloat, _ green : CGFloat, _ blue : CGFloat, _ alpha : CGFloat) -> UIColor{
        
        return UIColor(red:red/255.0, green:green/255.0, blue:blue/255.0, alpha:alpha)
        
    }
    class func buttonShadowColor() -> UIColor{
        return UIColor.colorWith(153, 196, 250, 1.0)
    }    

    class func buttonBorderColor() -> UIColor{
        return UIColor.colorWith(255, 255, 255, 0.5)
    }
    
    class func onboardingTitleColor() -> UIColor{
        return UIColor.colorWith(245.0, 245.0, 245.0, 1.0)
    }
    
    class func toastBackgroundColor() -> UIColor{
        return UIColor.colorWith(240, 101, 97, 1.0)
    }
    
    class func toastBackgroundSuccess() -> UIColor{
        return UIColor.colorWith(49, 177, 237, 1.0)
    }
    
    class func searchTextFieldBorderColor() -> UIColor{
        return UIColor.colorWith(49, 177, 237, 1.0)
    }
    
    class func tabbarFontColor() -> UIColor{
        return UIColor.colorWith(146, 146, 146, 1.0)
    }
    class func tabbarSelectedFontColor() -> UIColor{
        return UIColor.colorWith(0, 183, 234, 1.0)
    }
    // MARK: Button Bar Related
    /* Description : Returns color for unselected state */
    class func unSelectedTabTextColor() -> UIColor {
        return UIColor.colorWith(153, 153, 153, 1.0)
    }
    
    /* Description : Returns color for selected state */
    class func selectedTabTextColor() -> UIColor {
        return UIColor.colorWith(0, 183, 234, 1.0)
    }
    class func theamBackgroundColor() -> UIColor {
        return UIColor.colorWith(38, 37, 47, 1.0)
    }
    
    class func myTripBackgroundColor() -> UIColor{
        return UIColor.colorWith(44, 43, 48, 1.0)
    }
    //xr
    /*class func linkColor() -> UIColor{
        return UIColor.colorWith(64, 162, 241, 0.62)
    }*/
    class func clearFilterLinkColor() -> UIColor{
        return UIColor.colorWith(255, 255, 255, 0.74)
    }
    class func blueButtonColor() -> UIColor{
        return UIColor.colorWith(0, 183, 234, 1.0)
    }
    
    class func appBlueColor(withAlpha alpha: CGFloat = 0.22) -> UIColor{
        return UIColor.colorWith(0, 183, 234, alpha)
    }
    
    class func placeholderColor() -> UIColor{
        return UIColor.white.withAlphaComponent(0.43)
    }
    
    //MARK: Tutorials Color
    class func shadow() -> UIColor{
        return UIColor.colorWith(0, 0, 0, 0.15)
    }
    
    class func tutorialPopUpshadow() -> UIColor{
        return UIColor.colorWith(0, 0, 0, 0.45)
    }
    
    class func tutorialTextColor() -> UIColor{
        return UIColor.colorWith(56, 58, 63, 1.0)
    }

    //MARK: Filters Color
    class func filterOrange() -> UIColor{
        return UIColor.colorWith(248, 73, 44, 1.0)
    }
    
    class func filterPink() -> UIColor{
        return UIColor.colorWith(174, 0, 215, 1.0)
    }
    
    class func filterLime() -> UIColor{
        return UIColor.colorWith(60, 208, 162, 1.0)
    }
    
    class func filterGreen() -> UIColor{
        return UIColor.colorWith(59, 161, 72, 1.0)
    }
    
    class func filterBlue() -> UIColor{
        return UIColor.colorWith(13, 84, 206, 1.0)
    }
    class func completedRouteColor() -> UIColor{
        return UIColor.colorWith(33, 211, 83, 1.0)
    }
    class func popularRouteColor() -> UIColor{
        return UIColor.colorWith(73, 144, 226, 1.0)
    }
    class func routeEasyColor() -> UIColor{
        return UIColor.colorWith(248, 231, 28, 1.0)
    }
    class func routeIntermidiateColor() -> UIColor{
        return UIColor.colorWith(255, 133, 0, 1.0)
    }
    class func routeDificultColor() -> UIColor{
        return UIColor.colorWith(239, 31, 68, 1.0)
    }
    class func routeProColor() -> UIColor{
        return UIColor.colorWith(186, 29, 96, 1.0)
    }
    class func routeLevelColor() -> UIColor{
        return UIColor.colorWith(63, 56, 56, 0.6)
    }
    class func mapFilterGreen() -> UIColor{
         return UIColor.colorWith(33, 211, 83, 1.0)
    }
    class func mapFilterBlue() -> UIColor{
        return UIColor.colorWith(73, 144, 226, 1.0)
    }
    class func mapFilterRed() -> UIColor{
        return UIColor.colorWith(255, 59, 94, 1.0)
    }
    class func mapFilterOrrange() -> UIColor{
        return UIColor.colorWith(255, 94, 58, 1.0)
    }
    class func tripColor() -> UIColor{
         return UIColor.colorWith(74, 144, 226, 0.7)
    }
    class func tripSaveButtonGradientColor() -> [CGColor]{
        return [UIColor.colorWith(38, 188, 234, 0.0).cgColor, UIColor.colorWith(119, 106, 255, 0.0).cgColor]
    }
    class func searchTableRowTextColor() -> UIColor{
        return UIColor.colorWith(68, 66, 76, 1.0)
    }
    class func popupBorderColor() -> UIColor{
        return UIColor.colorWith(155, 155, 155, 1.0)
    }
    
    class func addTripAlertButton() -> UIColor{
        return UIColor.colorWith(74, 74, 74, 1.0)
    }
    //xr
    /*class func separatorColor() -> UIColor{
        return UIColor.colorWith(255, 255, 255, 0.13)
    }*/
    class func inAppTermsColor() -> UIColor {
        return UIColor.colorWith(174, 173, 175, 1.0)
    }
}
