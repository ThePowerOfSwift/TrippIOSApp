//
//  BottomBorderTextField.swift
//  Tripp
//
//  Created by Monu on 14/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class BottomBorderTextField: UITextField, UITextFieldDelegate {

    //-- Textfield configuration
    let border = CALayer()
    let height = CGFloat(1.0)
    let borderColor = UIColor.white.withAlphaComponent(0.25)
    var borderFrame : CGRect!
    fileprivate var characterSpace = 0.0
    fileprivate var isAddedNotification = false
    
    var placeholderColor: UIColor?
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        if borderFrame == nil {
            borderFrame = CGRect(x: 0, y: self.frame.size.height - height, width:  self.frame.size.width, height: height)
        }
        
        if isAddedNotification == false {
            isAddedNotification = true
            self.setupNotifications()
        }
        
        border.borderColor = borderColor.cgColor
        border.frame = borderFrame
        border.borderWidth = height
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
        //setAttributedPlaceholderCharacterSpacing()
        
        // Change placeholder color
        setupPlaceholder()
    }
    
    //Setup Placeholder
    func setupPlaceholder(){
        
        if self.placeholderColor == nil {
            self.placeholderColor = self.textColor!
        }
        
        let attributedText = NSMutableAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: self.placeholderColor!])
        
        if characterSpace != 0 {
            //let attributedString = NSMutableAttributedString(string: placeholder!)
            attributedText.addAttribute(NSAttributedStringKey.kern, value: characterSpace, range: NSMakeRange(0, (placeholder?.characters.count)!))
            //attributedText.append(attributedString)
        }
        
        self.attributedPlaceholder = attributedText
        
    }
    
    override func changePlaceholderColor(color: UIColor) {
        self.placeholderColor = color
    }
    
    override func paste(_ sender: Any?) {
        super.paste(sender)
    }
    
    func updateBottomBorderWithHeight(height:CGFloat){
        self.borderFrame = CGRect(x: 0, y: self.frame.size.height - height, width:  self.frame.size.width, height: 1.0)
    }
    
    func updateBorderFrame(frame : CGRect){
        self.borderFrame = frame
    }
    
    func setCharacterSpace(space:Double){
        self.characterSpace = space
    }
    
    private func setAttributedPlaceholderCharacterSpacing(){
        if characterSpace != 0 {
            let attributedString = NSMutableAttributedString(string: placeholder!)
            attributedString.addAttribute(NSAttributedStringKey.kern, value: characterSpace, range: NSMakeRange(0, (placeholder?.characters.count)!))
            attributedString.append(NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: self.placeholderColor!]))
            
            self.attributedPlaceholder = attributedString
            
        }
    }
    
    func setAttributedTextCharacterSpacing(){
        if characterSpace != 0, let _ = text {
            let attributedString = NSMutableAttributedString(string: text!)
            attributedString.addAttribute(NSAttributedStringKey.kern, value: characterSpace, range: NSMakeRange(0, (text?.characters.count)!))
            self.attributedText = attributedString
        }
    }
    
    func setupNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(BottomBorderTextField.textFieldDidChangeText(_:)), name:NSNotification.Name.UITextFieldTextDidChange, object: self)
    }
    
    @objc func textFieldDidChangeText(_ notification : NSNotification){
        self.setAttributedTextCharacterSpacing()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
