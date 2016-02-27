//
//  NSDate+Extensions.swift
//  KINNOSUKE-Agent
//
//  Created by Takeshita Hidenori on 2016/02/27.
//  Copyright © 2016年 taketin. All rights reserved.
//

import Foundation

extension NSDate {
    class func componentsByDate(date: NSDate = NSDate()) -> NSDateComponents {
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        let components = calendar!.components([.Year, .Month, .Day], fromDate: date)

        return components
    }
}