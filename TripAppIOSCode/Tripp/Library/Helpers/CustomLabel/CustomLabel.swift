//
//  CustomLabel.swift
//  Tripp
//
//  Created by Monu on 14/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {

    open class CustomLabel : UILabel {
        @IBInspectable open var characterSpacing:CGFloat = 5.8 {
            didSet {
                let attributedString = NSMutableAttributedString(string: self.text!)
                attributedString.addAttribute(NSAttributedStringKey.kern, value: self.characterSpacing, range: NSRange(location: 0, length: attributedString.length))
                self.attributedText = attributedString
            }
            
        }
    }

}
