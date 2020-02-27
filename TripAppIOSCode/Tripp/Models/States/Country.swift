//
//  Country.swift
//  Tripp
//
//  Created by Bharat Lal on 08/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import RealmSwift

class Country: Object {
    
    @objc dynamic var countryId = 0
    @objc dynamic var name: String?
    @objc dynamic var code: String?
    
}
