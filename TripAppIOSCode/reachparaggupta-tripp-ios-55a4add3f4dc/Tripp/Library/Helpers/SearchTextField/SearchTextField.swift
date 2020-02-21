//
//  SearchTextField.swift
//  Tripp
//
//  Created by Bharat Lal on 20/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class SearchTextField: UITextField {

    var leftImage: UIImageView?
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        self.layer.borderColor = UIColor.searchTextFieldBorderColor().cgColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 7.7
        self.layer.masksToBounds = true
        if self.leftImage == nil{
            self.addLeftView()
            self.changePlaceholderColor(color: self.textColor!)
        }
    }
    func addLeftView(){
        self.leftViewMode = UITextFieldViewMode.always
        leftImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 42, height: 40))
        leftImage?.contentMode = UIViewContentMode.center
        leftImage?.image = UIImage(named: icSearchIcon)
        self.leftView = leftImage
    }

    //MARK: - Helpers
    func textInsets() -> UIEdgeInsets {
        return UIEdgeInsetsMake(12.9, 0, 14.7, 14.2)
    }

}
