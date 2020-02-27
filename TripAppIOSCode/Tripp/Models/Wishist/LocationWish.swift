//
//  LocationWish.swift
//  Tripp
//
//  Created by Bharat Lal on 16/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import RealmSwift

class LocationWish: Object {
    
    @objc dynamic var locationWishlistId = 0
    @objc dynamic var latitude = ""
    @objc dynamic var longitude = ""
    @objc dynamic var address: String?
    @objc dynamic var isCompleted  = 0
    @objc dynamic var name: String?
    @objc dynamic var createdAt: String?
    
    override static func primaryKey() -> String? {
        return "locationWishlistId"
    }
    
}
