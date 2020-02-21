//
//  PopupViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 24/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import TTTAttributedLabel

protocol PopupActionDelegate: class {
    
    func popupActionTapped()
}

class PopupViewController: UIViewController, TTTAttributedLabelDelegate {
    
    //MARK: ------------------- Variables / Outlets  --------------------

    @IBOutlet weak var gotToSettingLabel: TTTAttributedLabel!
    @IBOutlet var tutorialPopupView: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var centerImg: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    weak var delegate: PopupActionDelegate?
    static var nibName: String {
        return String(describing: self)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    //MARK: ------------------- Life cycle  --------------------
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.popUpView.layer.cornerRadius = 5
        self.popUpView.layer.shadowOpacity = 0.8
        self.popUpView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.popUpView.backgroundColor = UIColor.white
        self.setupSettingLabel()
    }
    
    class func showTutorialFinish(){
        let popupVC = PopupViewController(nibName: PopupViewController.nibName, bundle: Bundle(for: PopupViewController.self))
        popupVC.view.frame = UIScreen.main.bounds
        appDelegate.window?.addSubview(popupVC.view)
        popupVC.popUpView.isHidden = true
        popupVC.tutorialPopupView.isHidden = false
        popupVC.showAnimate()
    }
    
    
    
    //MARK: ------------------- Open  --------------------
    class func showTutorialFinishAlert(controller: UIViewController, withDelegate delegate: PopupActionDelegate?){
        let bundle = Bundle(for: PopupViewController.self)
        let popupVC = PopupViewController(nibName: PopupViewController.nibName, bundle: bundle)
        controller.addChildViewController(popupVC)
        popupVC.view.frame = UIScreen.main.bounds
        controller.view.addSubview(popupVC.view)
        popupVC.didMove(toParentViewController: controller)
        popupVC.popUpView.isHidden = true
        popupVC.tutorialPopupView.isHidden = false
        popupVC.delegate = delegate
        popupVC.showAnimate()
    }
    
    open func showPopup(withImage image : UIImage, centerImageName:String, title:String, _ message: String, _ action: String, withDelegate delegate: PopupActionDelegate?)
    {
        //aView.addSubview(self.view)
        logoImg!.image = image
        actionButton.setTitle(action, for: .normal)
        messageLabel!.text = message
        titleLabel.text = title
        actionButton.isHidden = false
        confirmButton.isHidden = true
        cancelButton.isHidden = true
        
        self.popUpView.isHidden = false
        self.tutorialPopupView.isHidden = true
        
        self.delegate = delegate
        self.centerImg.image = UIImage(named: centerImageName)
        self.showAnimate()
    }
    
    open func showConfirmPopup(withImage image : UIImage, centerImageName:String, title:String , _ message: String, _ action: String, cancel:String, withDelegate delegate: PopupActionDelegate?)
    {
        logoImg!.image = image
        messageLabel!.text = message
        titleLabel.text = title
        actionButton.isHidden = true
        confirmButton.isHidden = false
        cancelButton.isHidden = false
        
        confirmButton.setTitle(action, for: .normal)
        cancelButton.setTitle(cancel, for: .normal)
        
        self.popUpView.isHidden = false
        self.tutorialPopupView.isHidden = true
        
        self.centerImg.image = UIImage(named: centerImageName)
        
        self.delegate = delegate
        self.showAnimate()
    }
    
     //MARK: ------------------- Private  --------------------
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if finished {
                self.view.removeFromSuperview()
            }
        });
    }
    
    func setupSettingLabel(){
        let attributedString = String.createAttributedString(text: goToSettingMessage, font: UIFont.openSensBold(size: 14.9), color: UIColor.white.withAlphaComponent(0.47), spacing: -0.5)
        
        let linkAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.colorWith(74, 74, 74, 1.0),
            NSAttributedStringKey.font: UIFont.openSensBold(size: 14.9),
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue
            ] as [NSAttributedStringKey : Any]
        
        gotToSettingLabel.delegate = self
        gotToSettingLabel.numberOfLines = 0
        gotToSettingLabel.textAlignment = NSTextAlignment.left
        gotToSettingLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        gotToSettingLabel.textInsets = .zero
        gotToSettingLabel.setText(attributedString)
        gotToSettingLabel.linkAttributes = linkAttributes
        gotToSettingLabel.activeLinkAttributes = linkAttributes
        
        let gotoRange = (goToSettingMessage as NSString).range(of:goToSettingMessage)
        let gotoURL = NSURL(string:LinkTapEvent.gotoSettingEvent)
        gotToSettingLabel.addLink(to: gotoURL as URL!, with:gotoRange)
        gotToSettingLabel.isUserInteractionEnabled = true
    }
    
     //MARK: ------------------- IBActions  --------------------
    
    @IBAction func closePopup(_ sender: AnyObject) {
        self.removeAnimate()
    }
    @IBAction func actionTapped(_ sender: AnyObject) {
        if let _ = self.delegate{
            delegate!.popupActionTapped()
        }
        
        self.removeAnimate()
    }
    
    //MARK: ------------------- Delegates  --------------------
    
    //MARK: TTTAttributedLabelDelegate
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {

        if let url = url, url.absoluteString == LinkTapEvent.gotoSettingEvent, let _ = self.delegate{
                    delegate!.popupActionTapped()
        }
    }
}
