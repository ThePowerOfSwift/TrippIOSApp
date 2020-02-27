//
//  ShadowView.swift
//  Tripp
//
//  Created by Monu on 21/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

@IBDesignable class ShadowView: UIView {
    
    // MARK: Inspectable properties
    @IBInspectable var position: CGPoint = .zero {
        didSet{
            self.setupView()
        }
    }
    
    @IBInspectable var blur: CGFloat = 0.0 {
        didSet{
            self.setupView()
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.black {
        didSet{
            self.setupView()
        }
    }

    private func setupView(){
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: position.x, height: position.y)
        self.layer.shadowRadius = blur
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = shadowColor.cgColor
    }
    
}
