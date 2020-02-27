//
//  SigninViewController.swift
//  Tripp
//
//  Created by Monu on 14/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class SigninViewController: UIViewController, TTTAttributedLabelDelegate {
    
    // MARK: - Variables / Outlets
    @IBOutlet weak var emailTextField: BottomBorderTextField!
    @IBOutlet weak var passwordTextField: BottomBorderTextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var signUpLabel: TTTAttributedLabel!
    @IBOutlet weak var forgotPasswordLabel: TTTAttributedLabel!
    @IBOutlet weak var backButton: UIButton!
    
    
    // MARK: - UIViewController life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.checkAndPushResetPassword()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction Methods
    @IBAction func signInButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        if Utils.signInValidation(email: self.emailTextField.text!, password: self.passwordTextField.text!) {
            self.signInUser()
        }
    }

    // MARK: - Private Methods
    private func setupView(){
        self.titleLabel.attributedText = (self.titleLabel.text!).attributedTextWith(spacing: 5.8)
        self.addSignUpLabel()
        addForgotPasswordLabel()
       //fatalError("crashing intensionly....")
    }
    
    private func addSignUpLabel(){
        let text = notYetRegistered
        
        let attributedString = String.createAttributedString(text: text, font: UIFont.openSensRegular(size: 14), color: UIColor.white.withAlphaComponent(0.47), spacing: 0.0)
        
        let linkAttributes = [
            //NSAttributedStringKey.foregroundColor: UIColor.linkColor(), //xr
            NSAttributedStringKey.font: UIFont.openSensRegular(size: 15),
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue
            ] as [NSAttributedStringKey : Any]
        
        signUpLabel.delegate = self
        signUpLabel.numberOfLines = 0
        signUpLabel.textAlignment = NSTextAlignment.left
        signUpLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        signUpLabel.textInsets = .zero
        signUpLabel.setText(attributedString)
        signUpLabel.linkAttributes = linkAttributes
        signUpLabel.activeLinkAttributes = linkAttributes
        
        let signInLinkRange = (text as NSString).range(of:signUp)
        let signInURL = NSURL(string:LinkTapEvent.signupEvent)
        signUpLabel.addLink(to: signInURL as URL!, with:signInLinkRange)
        signUpLabel.isUserInteractionEnabled = true
    }
    
    private func addForgotPasswordLabel(){
        let text = forgotPassword
        
        let attributedString = String.createAttributedString(text: text, font: UIFont.openSensRegular(size: 15), color: UIColor.white.withAlphaComponent(0.47), spacing: -0.5)
        
        let linkAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor(red: 212.0/255.0, green: 210.0/255.0, blue: 213.0/255.0, alpha: 0.5),
            NSAttributedStringKey.font: UIFont.openSensRegular(size: 15),
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue
            ] as [NSAttributedStringKey : Any]
        
        forgotPasswordLabel.delegate = self
        forgotPasswordLabel.numberOfLines = 0
        forgotPasswordLabel.textAlignment = NSTextAlignment.right
        forgotPasswordLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        forgotPasswordLabel.textInsets = .zero
        forgotPasswordLabel.setText(attributedString)
        forgotPasswordLabel.linkAttributes = linkAttributes
        forgotPasswordLabel.activeLinkAttributes = linkAttributes
        
        let forgotPasswordRange = (text as NSString).range(of:forgotPassword)
        let forgotPasswordURL = NSURL(string:LinkTapEvent.forgotPasswordEvent)
        forgotPasswordLabel.addLink(to: forgotPasswordURL as URL!, with:forgotPasswordRange)
        forgotPasswordLabel.isUserInteractionEnabled = true
    }
    
    //MARK: ------------------- Delegates  --------------------
    
    //MARK: TTTAttributedLabelDelegate
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        
        if let url = url {
            if url.absoluteString == LinkTapEvent.signupEvent {
                self.checkAndPushSignUp()
            }
            else if url.absoluteString == LinkTapEvent.forgotPasswordEvent {
                self.pushForgotPassword()
            }
        }
    }
    
    /**
     * @method signInUser
     * @discussion User Regsitration API.
     */
    private func signInUser(){
        AppLoader.showLoader()
        APIDataSource.login(service: .login(username: emailTextField.text!, password: passwordTextField.text!), handler: { (user, error) in
            AppLoader.hideLoader()
            
            if isGuardObject(user) {
                user?.deviceId = Devices.deviceIdentifier
                user!.saveUpdateUser()
                APIDataSource.updateDeviceToken()
                APIDataSource.fetchStates(handler: nil)
                DLog(message: "app email \(AppUser.currentUser().email)" as AnyObject)
                self.pushToHome() // Show home vc
                AnalyticsManager.login()
            }
            else {
                AppToast.showErrorMessage(message: error!)
                AppLoader.hideLoader()
            }
        })
    }

}
