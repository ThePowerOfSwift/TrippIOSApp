//
//  NSDate+Extension.swift
//  Tripp
//
//  Created by Bharat Lal on 20/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension Date {
    
    var currentUTCTimeZoneString: String {
        let formatter = AppSharedClass.shared.dateFormatter
        formatter.locale = Locale(identifier: DateUtils.localENUSPOSIX)
        formatter.timeZone = TimeZone(identifier: DateUtils.utc)
        formatter.dateFormat = AppDateFormat.UTCFormat
        return formatter.string(from: self)
    }
}
extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   == 1 { return "\(years(from: date)) year"   } else if years(from: date)   > 1 { return "\(years(from: date)) years"   }
        if months(from: date)  == 1 { return "\(months(from: date)) month"  } else if months(from: date)  > 1 { return "\(months(from: date)) month"  }
        if weeks(from: date)   == 1 { return "\(weeks(from: date)) week"   } else if weeks(from: date)   > 1 { return "\(weeks(from: date)) weeks"   }
        if days(from: date)    == 1 { return "\(days(from: date)) day"    } else if days(from: date)    > 1 { return "\(days(from: date)) days"    }
        if hours(from: date)   == 1 { return "\(hours(from: date)) hour"   } else if hours(from: date)   > 1 { return "\(hours(from: date)) hours"   }
        if minutes(from: date) == 1 { return "\(minutes(from: date)) minute" } else if minutes(from: date) > 1 { return "\(minutes(from: date)) minutes" }
        return ""
    }
}

struct DateUtils {
    static let localENUSPOSIX = "en_US_POSIX"
    static let utc = "UTC"
}
