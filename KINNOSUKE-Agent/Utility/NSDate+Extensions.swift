//
//  NSDate+Extensions.swift
//  KINNOSUKE-Agent
//
//  Created by Takeshita Hidenori on 2016/02/27.
//  Copyright © 2016年 taketin. All rights reserved.
//

import Foundation

extension Date {
    @nonobjc static let notificationHours = [9, 10, 11, 17, 18, 19]

    static func componentsByDate(_ date: Date = Date()) -> DateComponents {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let components = (calendar as NSCalendar).components([.year, .month, .day, .hour], from: date)

        return components
    }

    static func isNotificationTime() -> Bool {
        let dateComponents = Date.componentsByDate()

        if let _ = notificationHours.index(of: dateComponents.hour!) {
            return true
        } else {
            return false
        }
    }
}
