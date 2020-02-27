//
//  UITextfieldExtension.swift
//  Tripp
//
//  Created by Rubi Kumari on 02/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

extension UITextField {
    
    func setLeftPaddingPoints(_ amount: CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    
    func topCornerRadius()
    {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5, height: 5)).cgPath
        layer.mask = maskLayer
    }
    
    func bottomCornerRadius()
    {
        let maskPath = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: [.bottomLeft,.bottomRight],
                                    cornerRadii: CGSize(width: 5.0, height: 5.0))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        self.layer.mask = shape
    }
    
    @objc func changePlaceholderColor(color:UIColor){
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!,
                                                               attributes: [NSAttributedStringKey.foregroundColor: color])
    }
    
}
