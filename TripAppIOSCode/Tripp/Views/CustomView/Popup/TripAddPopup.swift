//
//  TripAddPopup.swift
//  Tripp
//
//  Created by Monu on 17/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

enum TripAddPopupActionType {
    case gotoMyTrip
    case addNewTrip
    case share
}
typealias TripAddPopupHandler = (_ action: TripAddPopupActionType) -> ()

class TripAddPopup: AlertBaseView {

    @IBOutlet weak var gotoMyTripButton: UIButton!
    @IBOutlet weak var addNewTripbutton: UIButton!
    @IBOutlet weak var tripSavedMessageButton: RoundedBorderButton!
    var actionHandler: TripAddPopupHandler?
    
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
    
    /**
     Initialiser method
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    required init(handler: @escaping TripAddPopupHandler){
        super.init(frame: .zero)
        self.actionHandler = handler
        setupView()
    }
    
    /**
     Sets up the view by loading it from the xib file and setting its frame
     */
    override func setupView() {
        view = loadViewFromXibFile(nibName: TripAddPopup.nibName)
        super.setupView()
        self.setupButtons()
        self.addShadowAndCornerRadius(radius: 6.4)
        self.tripSavedMessageButton.addCharacterSpace(space: -0.5)
        self.tripSavedMessageButton.changeBorderColor(color: UIColor.blueButtonColor(), borderRadius: 23.5)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        self.dismissbutton.isHidden = true
    }
    
    /*
     Updates constraints for the view. Specifies the height and width for the view
     */
    override func updateConstraints() {
        super.updateConstraints()
        // Popup
        addConstraint(NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 379))
        addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: UIScreen.main.bounds.size.width - 24))
        
    }
    
    private func setupButtons(){
        self.upderLineAttributedButton(button: self.gotoMyTripButton)
        self.upderLineAttributedButton(button: self.addNewTripbutton)
    }
    
    private func upderLineAttributedButton(button:UIButton){
        let underlineAttribute = [
            NSAttributedStringKey.font : UIFont.openSensBold(size: 15.0),
            NSAttributedStringKey.foregroundColor : UIColor.addTripAlertButton(),
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue
            ] as [NSAttributedStringKey : Any]
        
        let attributeString = NSMutableAttributedString(string: (button.titleLabel?.text)!, attributes: underlineAttribute)
        button.setAttributedTitle(attributeString, for: .normal)
    }

    
    //MARK: IBAction methods
    @IBAction func gotoMyTripButtonTapped(_ sender: Any) {
        if let handler = self.actionHandler{
            handler(.gotoMyTrip)
        }
        self.hideView()
    }
    
    @IBAction func addNewTripButtonTapped(_ sender: Any) {
        if let handler = self.actionHandler{
            handler(.addNewTrip)
        }
        self.hideView()
    }
    @IBAction func shareButtonTapped(_ sender: Any) {
        if let handler = self.actionHandler{
            handler(.share)
        }
        self.hideView()
    }
    
}
