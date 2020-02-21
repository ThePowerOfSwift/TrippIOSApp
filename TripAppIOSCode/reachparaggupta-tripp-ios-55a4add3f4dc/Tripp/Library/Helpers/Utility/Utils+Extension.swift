//
//  Utils+Extension.swift
//  Tripp
//
//  Created by Monu on 22/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation


extension Utils{
    
    class func yearRange() -> [String]{
        var years : [String] = []
        for i in 1900...self.currentYear() {
            years.append("\(i)")
        }
        return years
    }
    
    class func currentYear() ->Int{
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.year, from: date)
    }
    
}
