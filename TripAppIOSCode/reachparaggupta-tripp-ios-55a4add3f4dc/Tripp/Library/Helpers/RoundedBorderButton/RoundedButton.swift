//
//  RoundedButton.swift
//  Tripp
//
//  Created by Monu on 24/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    
    var characterSpace  = -0.5
    var gradiantColors:[CGColor] = UIColor.tripSaveButtonGradientColor()
    var gradientLocation:[NSNumber] = [0.0, 1.0]
    
    var shadowPoint: CGPoint = .zero
    var shadowBlur: CGFloat = 0.0
    var shadowColor: UIColor = UIColor.black
    var radius:CGFloat  = 22.3
    
    var gradientLayer: CAGradientLayer = CAGradientLayer()
    
    override func draw(_ rect: CGRect){
        self.clipsToBounds = true
        self.layer.cornerRadius = self.radius

    }
    
}
