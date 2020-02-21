//
//  RoundedBorderButton.swift
//  Tripp
//
//  Created by Monu on 14/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RoundedBorderButton: UIButton {

    //-- Button setup
    var radius:CGFloat      = 10.0
    let borderWidth:CGFloat = 1.0
    var characterSpace = -0.5
    var borderColor = UIColor.buttonBorderColor()
    
    override func draw(_ rect: CGRect) {
        //half of the width
        self.layer.cornerRadius = radius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        addCharacterSpace(space: CGFloat(characterSpace))
    }
    
    func addCharacterSpace(space: CGFloat){
        self.characterSpace = Double(space)
        if let text = self.titleLabel?.text, text.isEmpty == false {
            let titleText = String.createAttributedString(text: text, font: (self.titleLabel?.font)!, color: (self.titleLabel?.textColor)!, spacing: Float(space))
            self.setAttributedTitle(titleText, for: .normal)
        }
    }
    
    func changeBorderColor(color:UIColor, borderRadius:CGFloat){
        self.radius = borderRadius
        self.borderColor = color
        self.layer.cornerRadius = radius
        self.layer.borderColor = borderColor.cgColor
    }

}
