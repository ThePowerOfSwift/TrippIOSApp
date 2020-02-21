//
//  UIImageView+Extension.swift
//  Tripp
//
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import AlamofireImage


extension UIImageView {

    func setBackGroundImage(imageUrlStr: String?) {
        if !Validation.isValidString(imageUrlStr) {
            self.image = backGroundPlaceHolderImage

            return
        }
        let url = URL(string: imageUrlStr!)

        if isGuardObject(url as AnyObject?) {
            
            self.af_setImage(withURL: url!, placeholderImage: backGroundPlaceHolderImage)

        } else {
            self.image = backGroundPlaceHolderImage
        }
    }
    
}


