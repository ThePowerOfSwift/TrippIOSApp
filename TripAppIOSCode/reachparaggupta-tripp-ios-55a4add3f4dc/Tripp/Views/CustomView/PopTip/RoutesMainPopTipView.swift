//
//  RoutesMainPopTipView.swift
//  Tripp
//
//  Created by Bharat Lal on 09/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RoutesMainPopTipView: AlertBaseView {

    // variables/IBOutlets
    @IBOutlet weak var messageLabel: UILabel!
    var callBack: PopTipCallBack?
    static var nibName: String {
        return String(describing: self)
    }
    /**
     Initialiser method
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    required init(callBack: @escaping PopTipCallBack){
        super.init(frame: .zero)
        self.callBack = callBack
        setupView()
    }
    /*
     Updates constraints for the view. Specifies the height and width for the view
     */
    override func updateConstraints() {
        super.updateConstraints()
        // Popup
        addConstraint(NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 388))
        addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 350))
        
    }
    
    /**
     Sets up the view by loading it from the xib file and setting its frame
     */
    override func setupView() {
        view = loadViewFromXibFile(nibName: RoutesMainPopTipView.nibName)
        super.setupView()
        view.layer.cornerRadius = 12
        self.backgroundColor = UIColor.appBlueColor(withAlpha: 0.38)
        view.backgroundColor = UIColor.white.withAlphaComponent(0.92)
        self.messageLabel.createAttributedText(text: routeMainPopupTitle, boldTexts: [""])
        
        self.dismissbutton.isHidden = true
        self.addShadowAndCornerRadius(radius: 12)
        
    }
    //MARK: IBActions
    
    @IBAction func switchValueChanged(_ sender: Any) {
        
        self.perform(#selector(RoutesMainPopTipView.hideView), with: nil, afterDelay: 0.3)
       self.perform(#selector(RoutesMainPopTipView.showNextTip), with: nil, afterDelay: 0.6)
    }
    @objc func showNextTip(){
        if let handler = self.callBack{
            handler()
        }
    }

}
