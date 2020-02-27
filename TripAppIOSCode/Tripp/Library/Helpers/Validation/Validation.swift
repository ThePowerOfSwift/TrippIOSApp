//
//  Validation.swift
//  Tripp
//
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


let MIN_PASSWORD_LENGTH = 6 //characters
class Validation {

    //Check string is alpha numeric
    class func isAlphaNumeric(text: String) -> Bool{
        return !text.isEmpty && text.range(of: "[^a-zA-Z0-9 ]", options: .regularExpression) == nil
    }
    
    //Check Weather string is Valid or Not
    class func isValidString(_ str: String?) -> Bool {

        if (str ?? "").isEmpty {
            return false
        }
        return true
    }

    class func isValidZipCode(_ str: String?) -> Bool {

        if (str ?? "").isEmpty || (str?.characters.count > 6) {
            return false
        }
        return true
    }

    class func isValidPassword(_ str: String?) -> Bool {

        if !Validation.isValidString(str) {
            return false
        }
        // return true
        //let passwordRegex = "(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,14}"

       // let passwordRegex =  "((?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[.@#$%]).{8,14})"
        let passwordRegex =  "(.{6,12})"

        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: str)

    }

    //Check weather email address is valid
    class func isValidEmailAddress(_ email: String) -> Bool {
        let emailRegex = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"

        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return emailTest.evaluate(with: email)
    }

    //Check weather pone number entered is valid or not
    class func isValidPhoneNumber(_ phone: String) -> Bool {
        if ((phone as NSString).length < 6) || ((phone as NSString).length > 15) {
            return false
        }
        //let phoneRegex = "^+(?:[0-9] ?){6,14}[0-9]$"
        let phoneRegex = "[a-zA-Z0-9]+"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }

    class func isValidEmail(_ testStr: String) -> Bool {

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    class func isAlphanumericReferralCode(_ string: String) -> Bool {
        

        //Contains capital letters
        let filter = ".*[A-Z].*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", filter)
        if (!predicate.evaluate(with: string)) {
            return true
        }

        //        //Small Characters
        //        let filter2 = ".*[a-z].*"
        //        let predicate2 = NSPredicate(format: "SELF MATCHES %@", filter2)
        //        if (!predicate2.evaluateWithObject(string))
        //        {
        //            return true
        //        }

        //numbers
        let filter3 = ".*\\d.*"
        let predicate3 = NSPredicate(format: "SELF MATCHES %@", filter3)
        if (!predicate3.evaluate(with: string)) {
            return true
        }

        return false
    }

    //Check object must not be nil
    class func isValidObject(_ object: AnyObject?) -> Bool {
        
        if object! is NSNull || object == nil {
            return false
        }
        return true
    }

    class func validateUrl(_ stringURL: NSString) -> Bool {
        var urlRegEx = "((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        if stringURL.hasPrefix("http://") {
            urlRegEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        }
        let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [urlRegEx])
        _ = NSPredicate.withSubstitutionVariables(predicate)

        return predicate.evaluate(with: stringURL)
    }

    //check valid URl
    class func isValidUrl(_ url: URL?) -> Bool {
        if let _ = url {
            return true
        }
        return false
    }

    //get the valid device token
    class func validDeviceToken(_ deviceToken: Data) -> String {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        return deviceTokenString
    }

    class func validString(_ string: String?) -> String {
        if Validation.isValidString(string) {
            return string!
        }
        return ""
    }

}

