//
//  UIView+Glow.swift
//  Tripp
//
//  Created by Bharat Lal on 12/05/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC
import Dispatch

private var GLOWVIEW_KEY = "GLOWVIEW"

extension UIView {
    var glowView: UIView? {
        
        get {
            return objc_getAssociatedObject(self, &GLOWVIEW_KEY) as? UIView
        }
        set(newGlowView) {
            if newGlowView != nil {
                objc_setAssociatedObject(self, &GLOWVIEW_KEY, newGlowView!, .OBJC_ASSOCIATION_RETAIN)
            }
        }
    }
    
    func startGlowingWithColor(color:UIColor, intensity:CGFloat) {
        self.startGlowingWithColor(color: color, fromIntensity: 0.1, toIntensity: intensity, repeat: true)
    }
    
    func startGlowingWithColor(color:UIColor, fromIntensity:CGFloat, toIntensity:CGFloat, repeat shouldRepeat:Bool) {

        var image:UIImage
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale); do {
            self.layer.render(in: UIGraphicsGetCurrentContext()!)
            
            let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            
            color.setFill()
            
            path.fill(with: .sourceAtop, alpha:1.0)
            image = UIGraphicsGetImageFromCurrentImageContext()!
        }
        
        UIGraphicsEndImageContext()
        
        // Make the glowing view itself, and position it at the same
        // point as ourself. Overlay it over ourself.
        let glowingView = UIImageView(image: image)
        glowingView.center = self.center
        glowingView.tag = 999
        self.superview!.insertSubview(glowingView, aboveSubview:self)
        
        // We don't want to show the image, but rather a shadow created by
        // Core Animation. By setting the shadow to white and the shadow radius to
        // something large, we get a pleasing glow.
        glowingView.alpha = 0
        glowingView.layer.shadowColor = color.cgColor
        glowingView.layer.shadowOffset = CGSize.zero
        glowingView.layer.shadowRadius = 10
        glowingView.layer.shadowOpacity = 1.0
        
        // Create an animation that slowly fades the glow view in and out forever.
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = fromIntensity
        animation.toValue = toIntensity
        animation.repeatCount = shouldRepeat ? .infinity : 0 // HUGE_VAL = .infinity / Thanks http://stackoverflow.com/questions/7082578/cabasicanimation-unlimited-repeat-without-huge-valf
        animation.duration = 1.0
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        glowingView.layer.add(animation, forKey: "pulse")
        
        // Finally, keep a reference to this around so it can be removed later
        self.glowView = glowingView
    }
    
    func glowOnceAtLocation(point: CGPoint, inView view:UIView) {
        self.startGlowingWithColor(color: UIColor.white, fromIntensity: 0, toIntensity: 0.6, repeat: false)
        
        self.glowView!.center = point
        view.addSubview(self.glowView!)
        
        let delay: Double = 2 * Double(Int64(NSEC_PER_SEC))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.stopGlowing()
        }
    }
    
    func glowOnce() {
        self.startGlowing()
        
        let delay: Double = 2 * Double(Int64(NSEC_PER_SEC))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.stopGlowing()
        }
        
    }
    
    // Create a pulsing, glowing view based on this one.
    func startGlowing() {
        self.startGlowingWithColor(color: UIColor.white, intensity:0.6);
    }
    
    // Stop glowing by removing the glowing view from the superview
    // and removing the association between it and this object.
    func stopGlowing() {
        
        self.glowView!.removeFromSuperview()
        self.glowView = nil
    }
    
}
