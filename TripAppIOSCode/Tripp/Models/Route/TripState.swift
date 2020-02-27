//
//  TripState.swift
//  Tripp
//
//  Created by Monu on 25/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import RealmSwift

class TripState: Object {

    @objc dynamic var stateId = 0
    @objc dynamic var name = ""
    @objc dynamic var code = ""
    
    
    //MARK: Copy of a object
    override func copy() -> Any {
        let copy = TripState()
        copy.stateId = self.stateId
        copy.name = self.name
        copy.code = self.code
        return copy
    }
}
