//
//  Utils+Validation.swift
//  Tripp
//
//  Created by Monu on 18/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation


extension Utils{
    
    class func signInValidation(email: String, password: String) -> Bool{
        if email.isEmpty{
            AppToast.showErrorMessage(message: emailEmptyMessage)
            return false
        }
        else if !Validation.isValidEmail(email) {
            AppToast.showErrorMessage(message: emailValidationMessage)
            return false
        }
        else if password.isEmpty{
            AppToast.showErrorMessage(message: passwordEmptyValidation)
            return false
        }
        else if !Validation.isValidPassword(password){
            AppToast.showErrorMessage(message: passwordValidationMessage)
            return false
        }
        return true
    }
    
}
