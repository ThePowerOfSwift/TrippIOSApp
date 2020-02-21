//
//  TripWaypointCardTipView.swift
//  Tripp
//
//  Created by Bharat Lal on 10/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class TripWaypointCardTipView: UIView {
    
    //MARK: variables/IBOutlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageLabel2: UILabel!
    @IBOutlet weak var switchControl: UISwitch!

    var callBack: PopTipCallBack?
    static var nibName: String {
        return String(describing: self)
    }
    //MARK: local file message strings defines
    let deepPressMessage = "Deep press to drag and move the cards"
    let deepPressBoldText = "drag and move"
    let slideLeftMessage = "Slide left to delete any card"
    let slideLeftBoldText = "Slide left"
    
    //MARK: initializers
    func initialize(callBack: @escaping PopTipCallBack){
        self.callBack = callBack
        setupView()
    }
    
    class func fromNib<T : TripWaypointCardTipView>() -> T {
        return Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)![0] as! T
    }
    
    /**
     Sets up the view by loading it from the xib file and setting its frame
     */
    func setupView() {
        self.layer.cornerRadius = 12
        self.backgroundColor = UIColor.white.withAlphaComponent(0.92)
        self.messageLabel.createAttributedText(text: deepPressMessage, boldTexts: [deepPressBoldText])
        self.messageLabel2.createAttributedText(text: slideLeftMessage, boldTexts: [slideLeftBoldText])

    }
    
    @IBAction func switchValueChanged(_ sender: Any) {
        
        if let handler = self.callBack{
            handler()
        }
    }
}
