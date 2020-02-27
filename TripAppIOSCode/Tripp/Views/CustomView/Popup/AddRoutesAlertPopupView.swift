//
//  AddRoutesAlertPopupView.swift
//  Tripp
//
//  Created by Bharat Lal on 24/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

typealias PopupAlertCallback = (_ buttonIndex: Int) -> ()
class AddRoutesAlertPopupView: AlertBaseView {
    
    
    // variables IBOutlets
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    var alertMessage = ""
    var questionMessage = ""
    var alertActionTitle = "Remove"
    
    static var nibName: String {
        return String(describing: self)
    }
    var callback: PopupAlertCallback?
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
    required init(_ message: String, _ question: String = "", actionButtonTitle: String, handler: @escaping PopupAlertCallback){
        super.init(frame: .zero)
        callback = handler
        self.alertMessage = message
        self.alertActionTitle = actionButtonTitle
        if !question.isEmpty{
            self.questionMessage = question
        }
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
        addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 444))
        addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: UIScreen.main.bounds.size.width - 24))
        
    }
    /**
     Sets up the view by loading it from the xib file and setting its frame
     */
    override func setupView() {
        view = loadViewFromXibFile(nibName: AddRoutesAlertPopupView.nibName)
        super.setupView()
        view.layer.cornerRadius = 6.4
        bottomView.layer.addBorder(edge: .top, color: UIColor.popupBorderColor(), thickness: 1.0)
        actionButton.layer.addBorder(edge: .left, color: UIColor.popupBorderColor(), thickness: 1.0)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        self.messageLabel.text = self.alertMessage
        if !self.questionMessage.isEmpty{
            self.questionLabel.text = self.questionMessage
        }
        self.actionButton.setTitle(self.alertActionTitle, for: .normal)
    }
    //MARK: IBActions
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        if let handler = self.callback{
            handler(2)
        }
        self.hideView()
    }
    @IBAction func cancelTapped(_ sender: UIButton) {
         self.hideView()
    }
    
}
