//
//  UIButton+Extension.swift
//  Tripp
//
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit


extension UIButton {
    
    func characterSpace(space: Float){
        if !(self.titleLabel?.text?.isEmpty)! {
            let titleText = String.createAttributedString(text: (self.titleLabel?.text)!, font: (self.titleLabel?.font)!, color: (self.titleLabel?.textColor)!, spacing: space)
            self.setAttributedTitle(titleText, for: .normal)
        }
    }
    
}
