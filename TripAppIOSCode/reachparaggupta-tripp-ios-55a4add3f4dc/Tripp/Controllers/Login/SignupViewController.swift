//
//  SignupViewController.swift
//  Tripp
//
//  Created by Monu on 14/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class SignupViewController: UIViewController, TTTAttributedLabelDelegate {

    // MARK: - Variables / Outlets
    @IBOutlet weak var emailTextField: BottomBorderTextField!
    @IBOutlet weak var passwordTextField: BottomBorderTextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var termsConditionsLabel: TTTAttributedLabel!
    @IBOutlet weak var signInLabel: TTTAttributedLabel!
    
    // MARK: - UIViewController life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    // MARK: - IBAction Methods
    @IBAction func signUpButtonTapped(_ sender: Any) {
        self.view.endEditing(true) // Dissmiss keyboard if it is appear
        if Utils.signInValidation(email: self.emailTextField.text!, password: self.passwordTextField.text!) {
            self.registerUser()
        }
    }
    
    // MARK: - Private Methods
    private func setupView(){
        self.titleLabel.attributedText = (self.titleLabel.text!).attributedTextWith(spacing: 5.8)
        self.emailTextField.attributedPlaceholder = (self.emailTextField.placeholder!).attributedTextWith(spacing: -0.5)
        self.passwordTextField.attributedPlaceholder = (self.passwordTextField.placeholder!).attributedTextWith(spacing: -0.5)
        self.addSignInLabel()
        addTermsConditionsLabel()
        
    }
    
    private func addSignInLabel(){
        let text = registerdUserSignIn
        
        let attributedString = String.createAttributedString(text: text, font: UIFont.openSensRegular(size: 14), color: UIColor.white.withAlphaComponent(0.5), spacing: 0.0)
        
        let linkAttributes = [
            //NSAttributedStringKey.foregroundColor: UIColor.linkColor(),//xr
            NSAttributedStringKey.font: UIFont.openSensRegular(size: 15),
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue
            ] as [NSAttributedStringKey : Any]
        
        signInLabel.delegate = self
        signInLabel.numberOfLines = 0
        signInLabel.textAlignment = NSTextAlignment.left
        signInLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        signInLabel.textInsets = .zero
        signInLabel.setText(attributedString)
        signInLabel.linkAttributes = linkAttributes
        signInLabel.activeLinkAttributes = linkAttributes
        
        let signInLinkRange = (text as NSString).range(of:signIn)
        let signInURL = NSURL(string: LinkTapEvent.signinEvent)
        signInLabel.addLink(to: signInURL as URL!, with:signInLinkRange)
        signInLabel.isUserInteractionEnabled = true
    }
    
    private func addTermsConditionsLabel(){
        let text = termsAndConditionsAndPrivacypolicy
        
        let attributedString = String.createAttributedString(text: text, font: UIFont.openSensRegular(size: 14), color: UIColor.white.withAlphaComponent(0.47), spacing: -0.4)
        
        let linkAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor(red: 64.0/255.0, green: 162.0/255.0, blue: 241.0/255.0, alpha: 0.5),
            NSAttributedStringKey.font: UIFont.openSensRegular(size: 14),
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue
            ] as [NSAttributedStringKey : Any]
        
        termsConditionsLabel.delegate = self
        termsConditionsLabel.numberOfLines = 0
        termsConditionsLabel.textAlignment = NSTextAlignment.left
        termsConditionsLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        termsConditionsLabel.textInsets = .zero
        termsConditionsLabel.setText(attributedString)
        termsConditionsLabel.linkAttributes = linkAttributes
        termsConditionsLabel.activeLinkAttributes = linkAttributes
        
        let termsConditionRange = (text as NSString).range(of:termsAndConditions)
        let termsConditionUrl = NSURL(string: LinkTapEvent.termsAndConditionEvent)
        termsConditionsLabel.addLink(to: termsConditionUrl as URL!, with:termsConditionRange)
        
        let privacyPolicyRange = (text as NSString).range(of:privacyPolicy)
        let privacyPolicyURL = NSURL(string: LinkTapEvent.privacyPolicyEvent)
        termsConditionsLabel.addLink(to: privacyPolicyURL as URL!, with:privacyPolicyRange)
        
        termsConditionsLabel.isUserInteractionEnabled = true
    }
    
    //MARK: ------------------- Delegates  --------------------
    
    //MARK: TTTAttributedLabelDelegate
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        
        if let url = url {
            if url.absoluteString == LinkTapEvent.signinEvent {
                self.checkAndPushSignIn()
            }
            else if url.absoluteString == LinkTapEvent.termsAndConditionEvent {
                self.pushAppWebView(type: .termsAndConditions)
            }
            else if url.absoluteString == LinkTapEvent.privacyPolicyEvent {
                self.pushAppWebView(type: .privacyPolicy)
            }
        }
    }
    
    /**
     * @method registerUser
     * @discussion User Regsitration API.
     */
    private func registerUser(){
        AppLoader.showLoader()
        APIDataSource.register(service: .register(email: emailTextField.text!, password: passwordTextField.text!), handler: { (user, error) in
            AppLoader.hideLoader()
            if isGuardObject(user) {
                user?.deviceId = Devices.deviceIdentifier
                user!.saveUpdateUser()
                APIDataSource.updateDeviceToken()
                APIDataSource.fetchStates(handler: nil)
//                self.pushSignUpSuccess(email: self.emailTextField.text!) // show update profile details
                self.pushToHome()
                AnalyticsManager.signUp()
                FacebookManager.logCompletedRegistrationEvent()
            }
            else {
                AppToast.showErrorMessage(message: error!)
            }
        })
    }

}
