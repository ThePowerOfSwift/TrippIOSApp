//
//  ForgotPasswordViewController.swift
//  Tripp
//
//  Created by Monu on 14/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    // MARK: - Variables / Outlets
    @IBOutlet weak var emailTextField: BottomBorderTextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - UIViewController life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction Methods
    @IBAction func continueButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        if isValidateTextFields() {
            self.forgotPassword()
        }
    }

    // MARK: - Validations
    func isValidateTextFields() -> Bool
    {
        if self.emailTextField.isEmpty(){
            AppToast.showErrorMessage(message: emailEmptyMessage)
            return false
        }
        if !Validation.isValidEmail(emailTextField.text!) {
            AppToast.showErrorMessage(message: emailValidationMessage)
            return false
        }
        
        return true
    }
    
    // MARK: - Private Methods
    
    /**
     * @method setupView
     * @discussion Setup view UI.
     */
    func setupView(){
        self.titleLabel.attributedText = (self.titleLabel.text!).attributedTextWith(spacing: 5.8)
    }
    
    /**
     * @method forgotPassword
     * @discussion Forgot Password API.
     */
    private func forgotPassword(){
        AppLoader.showLoader()
        APIDataSource.forgotPassword(service: .forgotPassword(email: emailTextField.text!)) { (message, error) in
            AppLoader.hideLoader()
            if isGuardObject(message) {
                self.emailTextField.text = ""
                AppToast.showSuccessMessage(message: message!)
            }
            else{
                AppToast.showErrorMessage(message: error!)
            }
        }
    }

}
