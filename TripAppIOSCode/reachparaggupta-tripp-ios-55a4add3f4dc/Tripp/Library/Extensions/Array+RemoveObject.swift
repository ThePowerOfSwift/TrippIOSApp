//
//  Array+RemoveObject.swift
//  Tripp
//
//  Created by Bharat Lal on 14/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension Array {
    
    mutating func removeObject<T>(obj: T) where T : Equatable {
        self = self.filter({$0 as? T != obj})
    }
    
}
