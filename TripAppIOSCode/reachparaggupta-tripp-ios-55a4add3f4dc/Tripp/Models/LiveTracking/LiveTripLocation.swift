//
//  LiveTripLocation.swift
//  Tripp
//
//  Created by Bharat Lal on 21/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import RealmSwift

class LiveTripLocation: Object {
    @objc dynamic var lat = ""
    @objc dynamic var lon = ""
    @objc dynamic var locationId = 0
    @objc dynamic var tripId = 0
    
}


