//
//  PlaceholderTextView.swift
//  Tripp
//
//  Created by Monu on 28/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class PlaceholderTextView: UITextView {
    
    var placeholderLabel: UILabel?
    
    override var text: String!{
        didSet{
            if self.isEmpty(){
                self.placeholderLabel?.isHidden = false
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(PlaceholderTextView.textFieldDidBeginEdit(_:)), name:NSNotification.Name.UITextViewTextDidBeginEditing, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(PlaceholderTextView.textFieldDidEndEdit(_:)), name:NSNotification.Name.UITextViewTextDidEndEditing, object: self)
    }
    
    @objc func textFieldDidBeginEdit(_ notification : NSNotification){
        self.placeholderLabel?.isHidden = true
    }
    
    @objc func textFieldDidEndEdit(_ notification : NSNotification){
        if self.isEmpty(){
            self.placeholderLabel?.isHidden = false
        }
    }
    
    //MARK: Setup Placeholder
    public var placeholder:String?{
        didSet{
            setupPlaceholder()
        }
    }
    
    override var textContainerInset: UIEdgeInsets{
        didSet{
            adjustPLaceholderFrame()
        }
    }
    
    private func setupPlaceholder(){
        if placeholderLabel == nil {
            let textInset = self.textContainerInset
            placeholderLabel = UILabel(frame: CGRect(x: textInset.left, y: textInset.top, width: self.frame.size.width - (textInset.left+textInset.right) , height: 20))
            placeholderLabel?.textColor = self.textColor
            placeholderLabel?.font = self.font
            self.addSubview(placeholderLabel!)
        }
        
        placeholderLabel?.text = placeholder
    }
    
    private func adjustPLaceholderFrame(){
        let textInset = self.textContainerInset
        self.placeholderLabel?.frame = CGRect(x: textInset.left, y: textInset.top, width: self.frame.size.width - (textInset.left+textInset.right) , height: 20)
    }

}
