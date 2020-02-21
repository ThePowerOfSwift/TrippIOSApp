//
//  UITextField+Extensions.swift
//  Tripp
//
//  Created by Bharat Lal on 18/05/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

private var kAssociationKeyMaxLength: Int = 0

extension UITextField{
    
    // set max character limit
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength() {
        guard let prospectiveText = self.text,
            prospectiveText.characters.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        text = prospectiveText.substring(to: maxCharIndex)
        selectedTextRange = selection
    }
    // check if text field is empty
    func isEmpty()->Bool{
        
        guard let string = self.text else {
            return true
        }
        let whitespaceSet = CharacterSet.whitespaces
        return string.trimmingCharacters(in: whitespaceSet).isEmpty
    }
    func checkMaxLimit(string: String, and range: NSRange, allowedChars limit: Int) -> Bool{
        let nsString = NSString(string: self.text!)
        let newText = nsString.replacingCharacters(in: range, with: string)
        return  newText.characters.count <= limit
    }
    
    func condenseWhitespace() -> String {
        
        let textFieldText = self.text
        
        return textFieldText!.components(separatedBy: CharacterSet.whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
    
}
