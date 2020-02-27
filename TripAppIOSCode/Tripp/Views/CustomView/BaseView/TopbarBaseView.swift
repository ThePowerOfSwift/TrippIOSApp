//
//  TopbarBaseView.swift
//  Tripp
//
//  Created by Monu on 20/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class TopbarBaseView: UIView {

    var isExpand = true
    
    func expandOrCollapse(){
        self.isExpand = !self.isExpand
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.size.height = self.isExpand ? 163 : 90
            if self.isExpand {
                self.addBottomRoundedCorner()
            }
        }) { (success) in
            if !self.isExpand {
                self.addBottomRoundedCorner()
            }
        }
    }

    func addBottomRoundedCorner(){
        let layer = CAShapeLayer()
        var rect = self.bounds
        rect.size.width = Global.screenRect.size.width
        layer.path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 12, height: 12)).cgPath
        self.layer.mask = layer
    }
}
