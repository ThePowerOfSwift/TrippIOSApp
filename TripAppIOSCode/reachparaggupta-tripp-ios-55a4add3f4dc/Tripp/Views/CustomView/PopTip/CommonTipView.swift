//
//  CommonTipView.swift
//  Tripp
//
//  Created by Bharat Lal on 09/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
typealias PopTipCallBack = ()->()
class CommonTipView: UIView {

    // variables/IBOutlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tipIconImageView: UIImageView!
     @IBOutlet weak var switchControl: UISwitch!
    var message = ""
    var imageName = ""
    var boldTexts = [""]
    var callBack: PopTipCallBack?
    static var nibName: String {
        return String(describing: self)
    }
    
    func initialize(message: String, boldTexts:[String], imageName: String, callBack: @escaping PopTipCallBack){
        self.message = message
        self.imageName = imageName
        self.boldTexts = boldTexts
        self.callBack = callBack
        setupView()
    }
    
    class func fromNib<T : CommonTipView>() -> T {
        return Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)![0] as! T
    }

    /**
     Sets up the view by loading it from the xib file and setting its frame
     */
     func setupView() {
        self.layer.cornerRadius = 12
        self.backgroundColor = UIColor.white.withAlphaComponent(0.92)
        self.messageLabel.createAttributedText(text: self.message, boldTexts: self.boldTexts)
        self.tipIconImageView.image = UIImage(named: self.imageName)
       // self.addShadowAndCornerRadius(radius: 12)
    }
    @IBAction func switchValueChanged(_ sender: Any) {
        
        if let handler = self.callBack{
            handler()
        }
    }
}
