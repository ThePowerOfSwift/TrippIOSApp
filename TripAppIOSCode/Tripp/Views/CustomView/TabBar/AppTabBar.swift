//
//  AppTabBar.swift
//  Tripp
//
//  Created by Bharat Lal on 20/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class AppTabBar: UITabBar {
    
//    override func sizeThatFits(_ size: CGSize) -> CGSize {
//        let sizeThatFits = super.sizeThatFits(size)
//
//        return CGSize(width: sizeThatFits.width, height: 64)
//    }
    
    override func draw(_ rect: CGRect) {
        self.layer.shadowOffset = CGSize(width: 0, height: -5)
        self.layer.shadowRadius = 8
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
    }
    
    var oldSafeAreaInsets = UIEdgeInsets.zero
    
    @available(iOS 11.0, *)
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        
        if oldSafeAreaInsets != safeAreaInsets {
            oldSafeAreaInsets = safeAreaInsets
            
            invalidateIntrinsicContentSize()
            superview?.setNeedsLayout()
            superview?.layoutSubviews()
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        if #available(iOS 11.0, *) {
            let bottomInset = safeAreaInsets.bottom
            // size = CGSize(width: size.width, height: 98)
            if bottomInset > 0 && size.height > 50 {
                size = CGSize(width: size.width, height: 98)
            } else {
                size = CGSize(width: size.width, height: 64)
            }
        }else {
            size = CGSize(width: size.width, height: 64)
        }
        return size
    }
}
