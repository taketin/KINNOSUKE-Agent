//
//  NSDate+Extensions.swift
//  KINNOSUKE-Agent
//
//  Created by Takeshita Hidenori on 2016/02/27.
//  Copyright © 2016年 taketin. All rights reserved.
//

import Foundation

extension NSDate {
    @nonobjc static let notificationHours = [9, 10, 11, 17, 18, 19]

    class func componentsByDate(date: NSDate = NSDate()) -> NSDateComponents {
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        let components = calendar!.components([.Year, .Month, .Day, .Hour], fromDate: date)

        return components
    }

    class func isNotificationTime() -> Bool {
        let dateComponents = NSDate.componentsByDate()

        if let _ = notificationHours.indexOf(dateComponents.hour) {
            return true
        } else {
            return false
        }
    }
}