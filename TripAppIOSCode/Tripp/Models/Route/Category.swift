//
//  Category.swift
//  Tripp
//
//  Created by Bharat Lal on 18/09/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var categoryId = 0
    @objc dynamic var name = ""
    @objc dynamic var logo: String?
    
}

class CategoryStat: Category{
    @objc dynamic var totalDistance: Double = 0.0
}
