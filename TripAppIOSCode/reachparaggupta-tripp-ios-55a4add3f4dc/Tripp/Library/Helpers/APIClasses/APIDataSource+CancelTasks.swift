//
//  APIDataSource+CancelTasks.swift
//  Tripp
//
//  Created by Bharat Lal on 12/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import Alamofire

extension APIDataSource{
    
    class func stopAllSessions() {
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
        }
        
    }
}
