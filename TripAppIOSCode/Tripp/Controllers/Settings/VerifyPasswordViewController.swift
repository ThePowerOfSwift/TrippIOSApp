//
//  VerifyPasswordViewController.swift
//  Tripp
//
//  Created by Monu on 27/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class VerifyPasswordViewController: BaseViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: UIViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Private Methods
    private func setupView(){
        self.nextButton.titleLabel?.attributedText = String.createAttributedString(text: (self.nextButton.titleLabel?.text!)!, font: UIFont.openSensRegular(size: 18), color: UIColor.white, spacing: 2.2)
    }
    
    //MARK: IBAction Methods
    @IBAction func nextButtonTapped(_ sender: Any) {
        if isValidateTextFields() {
            verifyPassword()
        }
    }
    
    // MARK: - Validations
    func isValidateTextFields() -> Bool
    {
        if self.passwordTextField.isEmpty(){
            AppToast.showErrorMessage(message: passwordEmptyValidation)
            return false
        }
        if !Validation.isValidPassword(self.passwordTextField.text){
            AppToast.showErrorMessage(message: passwordValidationMessage)
            return false
        }
        
        return true
    }
    
    //MARK: API Call
    /**
     * @method changePassword
     * @discussion Change password API.
     */
    private func verifyPassword(){
        self.view.endEditing(true)
        AppLoader.showLoader()
        APIDataSource.verifyPassword(service: .verifyPassword(password: self.passwordTextField.text!)) { (message, errorMessage) in
            AppLoader.hideLoader()
            if isGuardObject(message) {
                self.pushUpdateEmail()
            }
            else {
                AppToast.showErrorMessage(message: errorMessage!)
            }
        }
    }
}
