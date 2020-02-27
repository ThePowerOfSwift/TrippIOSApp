//
//  MarkerInfoWindow.swift
//  Tripp
//
//  Created by Bharat Lal on 26/09/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

class MarkerInfoWindow: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MarkerInfoWindow", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }

}
