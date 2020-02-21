//
//  NSMutableAttributedString+Extension.swift
//  Tripp
//
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit


extension NSMutableAttributedString {
    
    // Add the font attribute
    func setFontAttribute(font: UIFont, forString: String)
    {
        self.addAttribute(NSAttributedStringKey.font, value: font, range: (self.string as NSString).range(of: forString))
    }
    
    // Add Color attribute
    func setColorAttribute(color: UIColor, forString: String)
    {
        self.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: (self.string as NSString).range(of: forString))
    }
    
    // Add character spacing in the string
    func addSpaceBetweenGivenText(textGap: Float)-> NSMutableAttributedString
    {
        self.addAttribute(NSAttributedStringKey.kern, value: textGap, range: NSMakeRange(0, self.length))
        return self
    }
    
   
    func addSpaceBetweenLineAndGivenText(textGap: Float, lineSpacing lineSpace: Float, alignment textAlignment: NSTextAlignment)-> NSMutableAttributedString
    {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = textAlignment
        paragraph.lineSpacing = CGFloat(lineSpace);
        
        let paragraphAttribute = [NSAttributedStringKey.paragraphStyle : paragraph]
        
        self.addAttribute(NSAttributedStringKey.kern, value: textGap, range: NSMakeRange(0, self.length))
        self.addAttributes(paragraphAttribute, range: NSMakeRange(0, self.length))
        
        return self
    }
    
}
