//
//  UpdateEmailViewController.swift
//  Tripp
//
//  Created by Monu on 28/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class UpdateEmailViewController: BaseViewController {

    @IBOutlet weak var saveChangesButton: RoundedBorderButton!
    @IBOutlet weak var emailTextField: UITextField!
    
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
        self.saveChangesButton.changeBorderColor(color: UIColor.blueButtonColor(), borderRadius: 22.0)
    }
    
    //MARK: IBAction Methods
    @IBAction func saveChangesButtonTapped(_ sender: Any) {
        if isValidateTextFields(){
            updateEmail()
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
    
    //MARK: API Call
    /**
     * @method changePassword
     * @discussion Change password API.
     */
    private func updateEmail(){
        self.view.endEditing(true)
        AppLoader.showLoader()
        APIDataSource.updateProfile(service: .updateEmail(email: emailTextField.text!)) { (user, error) in
            AppLoader.hideLoader()
            if isGuardObject(user) {
                AppToast.showSuccessMessage(message: emailUpdate)
                AppUser.currentUser().updateUser(user: user!)
                self.popToRootViewController()
            }
            else{
                AppToast.showErrorMessage(message: error!)
            }
        }
    }
}
