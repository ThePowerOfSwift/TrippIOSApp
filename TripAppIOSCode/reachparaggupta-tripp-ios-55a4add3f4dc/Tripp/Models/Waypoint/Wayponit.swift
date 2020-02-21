//
//  Wayponit.swift
//  Tripp
//
//  Created by Bharat Lal on 05/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import RealmSwift

class Wayponit: Object {
    @objc dynamic var waypointId = 0
    @objc dynamic var name = ""
    @objc dynamic var address = ""
    @objc dynamic var latitude = ""
    @objc dynamic var longitude = ""
    @objc dynamic var indexNumber = 0
    @objc dynamic var city = ""
    @objc dynamic var state = ""
    @objc dynamic var country:String?
    
    var isTemp = false
    var waypointMedia = List<WaypointMedia>()
   
    
//    override static func primaryKey() -> String? {
//        return "waypointId"
//    }

}
