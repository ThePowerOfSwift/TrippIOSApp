//
//  BorderView.swift
//  Tripp
//
//  Created by Monu on 27/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class BorderView: UIView {
    
    //-- Button setup
    let radius:CGFloat      = 8.0
    let borderWidth:CGFloat = 1.0
    
    override func awakeFromNib() {
        //half of the width
        self.layer.cornerRadius = radius
        self.layer.borderColor = UIColor.buttonBorderColor().cgColor
        self.layer.borderWidth = borderWidth
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }

}
