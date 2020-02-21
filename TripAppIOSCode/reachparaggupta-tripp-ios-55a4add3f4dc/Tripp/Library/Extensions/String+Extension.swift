//
//  String+Extension.swift
//  Tripp
//
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

extension String {

    func isSame(_ string: String) -> Bool {
        return self == string
    }
    
    /**
     * @method To create attributed String.
     * @discussion this will create attributed string for button Title.
     * @return NSAttributedString.
     */
    
    static func createAttributedString(text:String, font:UIFont, color:UIColor, spacing:Float) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string:text, attributes: [
            NSAttributedStringKey.font: font,
            NSAttributedStringKey.foregroundColor: color,
            ])
        attributedString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSMakeRange(0, text.characters.count))
        return attributedString
    }
    
    func attributedTextWith(spacing:Float) -> NSAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSMakeRange(0, self.characters.count))
        return attributedString
    }
    func trim() -> String{
        let whitespaceSet = CharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: whitespaceSet)
    }
    
    func convertFormatOfDate(_ destinationFormat: String, originFormat: String = AppDateFormat.UTCFormat) -> String! {
        
        // Convert current String Date to NSDate
        guard let dateFromString = toDate(originFormat) else {
            DLog(message: "cant convert to date" as AnyObject)
            return ""
        }
        // Destination format :
        let dateDestinationFormat = AppSharedClass.shared.dateFormatter
        dateDestinationFormat.dateFormat = destinationFormat
        
        
        // Convert new NSDate created above to String with the good format
        let dateFormated = dateDestinationFormat.string(from: dateFromString)
        
        return dateFormated
        
    }
    func toDate(_ originFormat: String = AppDateFormat.UTCFormat) -> Date?{
        // Orginal format :
        let dateOriginalFormat = AppSharedClass.shared.dateFormatter
        dateOriginalFormat.dateFormat = originFormat
        
        dateOriginalFormat.locale = Locale(identifier: DateUtils.localENUSPOSIX)
        dateOriginalFormat.timeZone = TimeZone(identifier: DateUtils.utc)
        
        // Convert current String Date to NSDate
        return dateOriginalFormat.date(from: self)
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedStringKey.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}

