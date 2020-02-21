//
//  CircularImageView.swift
//  Tripp
//
//  Developed by Appster. All rights reserved.
//

import Foundation
import UIKit

class CircularImageView: UIImageView {
    var borderColor: UIColor = UIColor.white
    var borderWidth: CGFloat = 3.0
    var cornerRadius: CGFloat = 2.0

    override init(image: UIImage?) {
        super.init(image: image)
        setup()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    var setBorderWidth: CGFloat = 3.0 {
        didSet {
            borderWidth = setBorderWidth
        }
    }

    func setup() {
        self.clipsToBounds = true
        //half of the width
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.borderColor = borderColor.cgColor
        self.layer.shadowColor = UIColor.clear.cgColor
        self.contentMode = UIViewContentMode.scaleAspectFill
       // self.layer.borderWidth = borderWidth
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.clear.cgColor
    }

}
