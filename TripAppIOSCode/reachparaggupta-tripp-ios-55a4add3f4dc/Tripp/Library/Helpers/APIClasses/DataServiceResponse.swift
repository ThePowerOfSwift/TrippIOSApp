//
//  DataServiceResponse.swift
//  Tripp
//  Developed by Tripp. All rights reserved.
//

//---------------- This class is used to check Web service response type  in the the app ---------------------------------------

import Foundation

enum DataServiceResponse {

    case success
    case error(String?)
    case serverFail(String?) // this shouldn't really happen, but...
    case missingOrBadValue(String?)
    case unknown(String?)

    func successful() -> Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }

    }

}
