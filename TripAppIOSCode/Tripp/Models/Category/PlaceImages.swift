//
//  PlaceImages.swift
//  Tripp
//
//  Created by Bharat Lal on 01/09/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import Foundation
import RealmSwift

class PlaceImage: Object {
    
    @objc dynamic var placeImageId = 0
    @objc dynamic var image = ""
    @objc dynamic var placeId = 0
    @objc dynamic var createdAt = ""
}

