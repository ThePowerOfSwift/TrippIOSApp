//
//  PlaceCategory.swift
//  Tripp
//
//  Created by Bharat Lal on 01/09/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import Foundation
import RealmSwift

class PlaceCategory: Object {
    
    @objc dynamic var categoryId = 0
    @objc dynamic var name = ""
    @objc dynamic var image: String?
    @objc dynamic var isPurchased = 0
    @objc dynamic var details: String?
}
