//
//  ChangePasswordViewController.swift
//  Tripp
//
//  Created by Monu on 27/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit


class ChangePasswordViewController: BaseViewController {

    @IBOutlet weak var saveChangesButton: RoundedBorderButton!
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    //MARK: UIViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
    }

    //MARK: Private Methods
    private func setupView(){
        self.saveChangesButton.addCharacterSpace(space: -0.5)
        self.saveChangesButton.changeBorderColor(color: UIColor.blueButtonColor(), borderRadius: 22.0)
    }

    //MARK: IBAction Methods
    @IBAction func saveChangesButtonTapped(_ sender: Any) {
        if isValidateTextFields(){
            changePassword()
        }
    }
    
    // MARK: - Validations
    private func isValidateTextFields() -> Bool {
        if let message = self.validateTextFields() {
            AppToast.showErrorMessage(message: message)
            return false
        }
        else{
            return true
        }
    }
    //-- Validate all text fields
    private func validateTextFields() -> String?{
        if let error = validateCurrentPassword(){
            return error
        }
        else if let error = validateNewPassword(){
            return error
        }
        else if let error = validateConfirmPassword(){
            return error
        }
        return nil
    }
    //-- Validate current password
    private func validateCurrentPassword() -> String?{
        if self.currentPasswordTextField.isEmpty(){
            return currentPasswordValidation
        }
        else if !Validation.isValidPassword(self.currentPasswordTextField.text){
            return currentPasswordValidationMessage
        }
        return nil
    }
    //-- Vaidate new password
    private func validateNewPassword() -> String?{
        if self.newPasswordTextField.isEmpty(){
            return newPasswordEmptyValidation
        }
        else if !Validation.isValidPassword(self.newPasswordTextField.text){
            return newPasswordValidationMessage
        }
        return nil
    }
    //-- Validate confirm password
    private func validateConfirmPassword() -> String?{
        if self.confirmPasswordTextField.isEmpty(){
            return confirmPasswordEmptyValidation
        }
        if self.newPasswordTextField.text != self.confirmPasswordTextField.text{
            return confirmPasswordValidation
        }
        return nil
    }
    
    
    /**
     * @method changePassword
     * @discussion Change password API.
     */
    private func changePassword(){
        self.view.endEditing(true)
        AppLoader.showLoader()
        APIDataSource.changePassword(service: .changePassword(currentPassword: self.currentPasswordTextField.text!, newPassword: self.newPasswordTextField.text!)) { (message, errorMessage) in
            AppLoader.hideLoader()
            if isGuardObject(message) {
                AppToast.showSuccessMessage(message: message!)
                self.clearAllTextFields()
                self.popViewController()
            }
            else {
                AppToast.showErrorMessage(message: errorMessage!)
            }
        }
    }
    
    //MARK: Private Methods
    private func clearAllTextFields(){
        self.currentPasswordTextField.text = ""
        self.newPasswordTextField.text = ""
        self.confirmPasswordTextField.text = ""
    }
    
}
