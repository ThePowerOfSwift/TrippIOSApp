//
//  AppToast+Custome.swift
//  Tripp
//
//  Created by Monu on 19/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

class AppToast {
    
    //MARK: - Custom App Toast`
    
    class func showErrorMessage(message:String){
        NotificationView.showErrorMessage(message)
    }
    
    class func showSuccessMessage(message:String){
        NotificationView.showSuccess(message)
    }
    
}
