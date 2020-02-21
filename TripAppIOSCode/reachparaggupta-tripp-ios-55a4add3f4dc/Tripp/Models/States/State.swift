//
//  State.swift
//  Tripp
//
//  Created by Bharat Lal on 08/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import RealmSwift

class State: Object {
    
    @objc dynamic var stateId = 0
    @objc dynamic var name: String?
    @objc dynamic var code: String?
    @objc dynamic var lat: String?
    @objc dynamic var lon: String?
    @objc dynamic var country: Country?
    
    override static func primaryKey() -> String? {
        return "stateId"
    }

}
