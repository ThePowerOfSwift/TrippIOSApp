//
//  Extensions.swift
//  Tripp
//
//  Created by Bharat Lal on 13/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension UIView {
    func addShadowWithColor(color: UIColor?, opacity: Float?, offset: CGSize?, radius: CGFloat?) {
        layer.shadowColor = color?.cgColor ?? UIColor.black.cgColor
        layer.shadowOpacity = opacity ?? 1.0
        layer.shadowOffset = offset ?? CGSize.zero
        layer.shadowRadius = radius ?? 0
        layer.masksToBounds = false
    }
    
    
    func addBackgroundGradient(color1 : UIColor, color2 :UIColor) {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [ color1.cgColor, color2.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        
        self.layer.insertSublayer(gradient, at: 0)
        
    }
    
    func addVerticalBackgroundGradient(colors: [CGColor]) {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = colors
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        
        self.layer.insertSublayer(gradient, at: 0)
        
    }
    
    func roundCornersWithLayerMask(_ cornerRadii: CGFloat, corners: UIRectCorner) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: cornerRadii, height: cornerRadii))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
    func roundCorner(_ corners: UIRectCorner, radius: CGFloat) {
        var rect = self.bounds
        rect.size.width = Global.screenRect.size.width
        
        let maskPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.cgPath;
        self.layer.mask = maskLayer;
    }
    func addRightBorder(){
         let border = CALayer()
        border.borderColor = UIColor.colorWith(0, 183, 234, 0.43).cgColor
        border.frame = CGRect(x: self.bounds.size.width - 1, y: 6.4, width: 1, height: 48.3)
        border.borderWidth = 1
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
    }
    
    func videoThumbnail(url: String, handler: ((_ image: UIImage?) -> Void)?){
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activity.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        self.addSubview(activity)
        activity.startAnimating()
        VideoManager.thumbnail(for: url) { (image) in
            Utils.mainQueue {
                activity.stopAnimating()
                guard let complition = handler else{
                    if image != nil {
                        if let button = self as? UIButton{
                            button.setImage(image, for: .normal)
                        }else if let imageView = self as? UIImageView{
                            imageView.image = image
                        }
                    }
                    return
                }
                complition(image)
            }
        }
    }
    
    func imageFromS3(_ imageName: String, handler: ((_ image: UIImage?) -> Void)?){
            let activity = UIActivityIndicatorView(activityIndicatorStyle: .white)
            activity.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
            self.addSubview(activity)
            activity.startAnimating()
            
            AWSImageManager.sharedManger.imageWithName(imageName, completion: { (success, image) in
                activity.stopAnimating()
                if !success{
                    return
                }
                guard let complition = handler else {
                    if image !=  nil{
                        Utils.mainQueue {
                            if let button = self as? UIButton{
                                button.setImage(image, for: .normal)
                            }else if let imageView = self as? UIImageView {
                                imageView.image = image
                            }
                        }
                    }
                    return
                }
                    complition(image)
            })
        }
}
extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer();
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness);
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
}

extension UICollectionViewCell {
    
    static var itemIdentifier: String {
        return String(describing: self)
    }
    
}
extension UIResponder {
    var parentViewController: UIViewController? {
        return (self.next as? UIViewController) ?? self.next?.parentViewController
    }
}
