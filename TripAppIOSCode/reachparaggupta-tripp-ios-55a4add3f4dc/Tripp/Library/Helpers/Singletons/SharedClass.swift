//
//  AppSharedClass.swift
//  Tripp
//
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

class AppSharedClass {
    static let shared = AppSharedClass()
    var deviceId = ""
    var deviceToken = ""
    var dateFormatter = DateFormatter()
    var offlineRoute = OfflineRoute()
    var uploadedFileCount = 0
    var params = [[String : Any]]()

}
