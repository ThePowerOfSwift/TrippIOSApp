//
//  Double+Extension.swift
//  Tripp
//
//  Created by Monu on 02/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

let meterToMileUnit = 0.000621371

extension Double{
    
    func toMiles() -> String {
        if self <= 0 {
            return ""
        }
        return String(format: "%0.2f", self * meterToMileUnit)
    }
    
    func toTime() -> String{
        if self <= 0 {
            return ""
        }
        let hour = Int64(self) / 3600
        let minutes = (Int64(self) % 3600) / 60
        return "\(hour):\(minutes) Hours"
    }
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
