//
//  ResetPasswordViewController.swift
//  Tripp
//
//  Created by Monu on 20/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newPasswordTextField: BottomBorderTextField!
    @IBOutlet weak var confirmPasswordTextField: BottomBorderTextField!
    
    var token:String = ""
    
    // MARK: - UIViewController life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private Methods
    
    /**
     * @method setupView
     * @discussion Setup view UI.
     */
    private func setupView(){
        self.titleLabel.attributedText = (self.titleLabel.text!).attributedTextWith(spacing: 5.8)
        self.newPasswordTextField.attributedPlaceholder = (self.newPasswordTextField.placeholder!).attributedTextWith(spacing: -0.5)
        self.confirmPasswordTextField.attributedPlaceholder = (self.confirmPasswordTextField.placeholder!).attributedTextWith(spacing: -0.5)
    }
    
    //MARK: IBAction Methods
    @IBAction func changePasswordButtonTapped(_ sender: Any) {
        if isValidateTextFields() {
            self.resetPassword()
        }
    }
    
    // MARK: - Validations
    func isValidateTextFields() -> Bool
    {
        if self.newPasswordTextField.isEmpty(){
            AppToast.showErrorMessage(message: newPasswordEmptyValidation)
            return false
        }
        if !Validation.isValidPassword(self.newPasswordTextField.text){
            AppToast.showErrorMessage(message: newPasswordValidationMessage)
            return false
        }
        if self.confirmPasswordTextField.isEmpty(){
            AppToast.showErrorMessage(message: confirmPasswordEmptyValidation)
            return false
        }
        if self.newPasswordTextField.text != self.confirmPasswordTextField.text{
            AppToast.showErrorMessage(message: confirmPasswordValidation)
            return false
        }
        return true
    }
    
    //MARK: API Call
    /**
     * @method registerUser
     * @discussion User Regsitration API.
     */
    private func resetPassword(){
        AppLoader.showLoader()
        APIDataSource.resetPassword(service: .resetPassword(newPassword: self.newPasswordTextField.text!, token: self.token), handler: { (message, error) in
            AppLoader.hideLoader()
            if isGuardObject(message) {
                AppToast.showErrorMessage(message: message!)
                self.checkAndPushSignIn()
            }
            else {
                AppToast.showErrorMessage(message: error!)
            }
        })
    }

}
