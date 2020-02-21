//
//  UIImageView+Image.swift
//  Tripp
//
//  Created by Bharat Lal on 13/10/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func imageFromS3Name(_ name: String?, placeholder: UIImage?) {
        if let imageName = name, let url = URL(string: Utils.imageUrl(fromName: imageName)) {
            sd_setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
            sd_showActivityIndicatorView()
            sd_setImage(with: url, placeholderImage: placeholder)
        } else {
            self.image = placeholder
        }
    }
    
}
