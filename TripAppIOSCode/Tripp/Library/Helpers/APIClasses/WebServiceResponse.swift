//
//  WebServiceResponse.swift
//  Tripp
//
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

class WebServiceResponse {
    
    var message = ""
    var success = false
    var result: Any?
    // var pagination = Pagination()
    init(result: NSDictionary?, showFailureMessage: Bool = true) {
        guard let _ = result else{
            if showFailureMessage == true && !self.message.isSame(""){
                AppToast.showErrorMessage(message: message)
            }
            return
        }
        self.parseResultMeta(result: result, showFailureMessage: showFailureMessage)
    }
    
    private func parseResultMeta(result: NSDictionary?, showFailureMessage:Bool){
        if isGuardObject(result!["meta"]), let metaDict = result!["meta"]! as? NSDictionary {
            let statusCode = metaDict["code"] as! Int
            if statusCode == 200 {
                self.success = true
                // set result
                if isGuardObject(result!["data"]!), let res = result!["data"] {
                    self.result = res
                }
            }
            else {
                self.success = false
            }
            
            if isGuardObject(metaDict["message"]), let message = metaDict["message"]! as? String {
                self.message = message
            }
            
            if !self.success && showFailureMessage == true && !self.message.isSame("") {
                AppToast.showErrorMessage(message: self.message)
            }
            
        }
    }
}
