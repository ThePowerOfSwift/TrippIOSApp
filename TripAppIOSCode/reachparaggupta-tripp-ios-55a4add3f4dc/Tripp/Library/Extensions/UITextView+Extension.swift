//
//  UITextView+Extension.swift
//  Tripp
//
//  Created by Monu on 28/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

extension UITextView{
    
    func isEmpty()->Bool{
        
        guard let string = self.text else {
            return true
        }
        let whitespaceSet = CharacterSet.whitespaces
        return (string.trimmingCharacters(in: whitespaceSet).isEmpty)
    }
    
}
