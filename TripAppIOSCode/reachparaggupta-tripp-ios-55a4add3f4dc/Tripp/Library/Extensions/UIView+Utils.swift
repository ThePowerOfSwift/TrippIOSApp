//
//  UIView+Utils.swift
//  Tripp
//
//  Created by Monu on 03/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit


extension UIView{
    
    func roundedBorderWithColor(color:UIColor, borderRadius:CGFloat){
        self.layer.cornerRadius = borderRadius
        self.layer.borderColor = color.cgColor
    }
    
    func addShadowAndCornerRadius(radius: CGFloat, opacity: Float = 0.4){
        self.layer.cornerRadius = radius
        dropShadow(opacity: opacity, offset: CGSize(width: 0.0, height: 8.0), radius: 4.0)
        
    }
    func dropShadow(opacity: Float, offset: CGSize, radius: CGFloat){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offset
    }
    
}
extension UIView {
    func captureScreenshot() -> UIImage? {
        var image: UIImage?
        
        if #available(iOS 10.0, *) {
            let format = UIGraphicsImageRendererFormat()
            format.opaque = isOpaque
            let renderer = UIGraphicsImageRenderer(size: frame.size, format: format)
            image = renderer.image { context in
                drawHierarchy(in: frame, afterScreenUpdates: true)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(frame.size, isOpaque, UIScreen.main.scale)
            drawHierarchy(in: frame, afterScreenUpdates: true)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        return image
    }
}
extension UIView {
    func topSafeAreaConstaintsOnView(_ view: UIView) -> NSLayoutConstraint {
        let top: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            top = self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -20)
        } else {
            // Fallback on earlier versions
            top = self.topAnchor.constraint(equalTo: view.topAnchor)
        }
        return top
    }
    func bottomSafeAreaConstaintsOnView(_ view: UIView) -> NSLayoutConstraint {
        let bottom: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            bottom = self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        } else {
            // Fallback on earlier versions
            bottom = self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        }
        return bottom
    }
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        } else {
            return self.topAnchor
        }
    }
    
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.leftAnchor
        }else {
            return self.leftAnchor
        }
    }
    
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.rightAnchor
        }else {
            return self.rightAnchor
        }
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        } else {
            return self.bottomAnchor
        }
    }
}
