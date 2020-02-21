//
//  Vehicle.swift
//  Tripp
//
//  Created by Monu on 22/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import RealmSwift

class Vehicle: Object {

    @objc dynamic var vehicleId = 0
    @objc dynamic var userId = 0
    @objc dynamic var type = ""
    @objc dynamic var make = ""
    @objc dynamic var model = ""
    @objc dynamic var manufacturingYear = ""

    
    
    override static func primaryKey() -> String? {
        return "vehicleId"
    }
    
    
}
