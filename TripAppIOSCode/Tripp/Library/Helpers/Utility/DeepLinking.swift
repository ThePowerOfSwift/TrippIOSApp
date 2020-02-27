//
//  DeepLinking.swift
//  Tripp
//
//  Created by Monu on 19/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit


enum DeepLinkType {
    case changePassword
}

class DeepLinking: NSObject {

    //MARK: - Parse DeepLinking URL
    class func parse(url:URL) -> Bool {
        if url.absoluteString.contains(kChangePasswordDeppLinking){
            openResetPassword(url: url)
            return true
        }
        return false
    }
    
    class func openResetPassword(url:URL) {
        if AppUser.isLoginUser() == false {
            Global.resetPasswordToken = url.absoluteString.replacingOccurrences(of: kChangePasswordDeppLinking, with: "")
            Global.setLoginRootVC()
        }
    }
    
}
