//
//  Notification.swift
//  Tripp
//
//  Created by Bharat Lal on 19/01/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import Foundation
import RealmSwift

class UserNotification: Object {
    @objc dynamic var notificationId = 0
    @objc dynamic var message: String?
    @objc dynamic var createdAt: String?
    let type = RealmOptional<Int>()
    let isRead = RealmOptional<Int>()
}
