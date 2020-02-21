//
//  UILabel+Extension.swift
//  Tripp
//
//  Created by Pratik Grover on 24/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    
    func addcolor(color: UIColor, for text: String) {
        
        let range = (self.text! as NSString).range(of: text)
        let attribute = NSMutableAttributedString.init(string: self.text!)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: color , range: range)
        self.attributedText = attribute
    }
    
    func addFont(font: UIFont, for text: String) {
        
        let range = (self.text! as NSString).range(of: text)
        let attribute = NSMutableAttributedString.init(string: self.text!)
        attribute.addAttribute(NSAttributedStringKey.font, value: font , range: range)
        self.attributedText = attribute
    }
    
    func addCharactersSpacing(spacing:CGFloat, text:String) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSMakeRange(0, text.characters.count))
        self.attributedText = attributedString
    }
    
    func addCharacterSpacing(spacing:CGFloat, attributedText:NSAttributedString){
        //xr
        /*let attributedString = attributedText as! NSMutableAttributedString
        attributedString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSMakeRange(0, (text?.characters.count)!))
        self.attributedText = attributedString*/
    }
    func createAttributedText(text: String, boldTexts:[String]) {
        let attributedString = NSMutableAttributedString(string:text, attributes: [
            NSAttributedStringKey.font: UIFont.openSensRegular(size: 16),
            NSAttributedStringKey.foregroundColor: UIColor.tutorialTextColor(),
            ])
        
        for message in boldTexts {
            let range = (text as NSString).range(of:message)
            let attribute = [NSAttributedStringKey.font: UIFont.openSensBold(size: 16)]
            attributedString.addAttributes(attribute, range: range)
        }
        
        self.attributedText = attributedString
    }
    //MARK: Set Attributed Text Title and subtitle
    func setTitle(title:String, subTitle:String){
        let titel = String.createAttributedString(text: title+"\n", font: UIFont.openSensSemiBold(size: 27), color: UIColor.onboardingTitleColor(), spacing: 5.4)
        let subTitel = String.createAttributedString(text: subTitle, font: UIFont.openSensLight(size: 27), color: UIColor.onboardingTitleColor(), spacing: 5.4)
        
        let attrubutedString = NSMutableAttributedString()
        attrubutedString.append(titel)
        attrubutedString.append(subTitel)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0
        paragraphStyle.alignment = self.textAlignment
        
        attrubutedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrubutedString.length))

        
        self.attributedText = attrubutedString as NSAttributedString
    }
    
    func stringHeight(withWidth: CGFloat) -> CGFloat {
        let size = CGSize(width: withWidth, height: CGFloat.greatestFiniteMagnitude)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.paragraphStyle: paragraphStyle.copy()]
        let text = self.text! as NSString
        let rect = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return rect.size.height
    }
}

