//
//  NSColor+Extensions.swift
//  KINNOSUKE-Agent
//
//  Created by Takeshita Hidenori on 2016/02/20.
//  Copyright © 2016年 taketin. All rights reserved.
//

import Cocoa

extension NSColor {
    static func hex(color: UInt32, alpha: CGFloat = 1.0) -> NSColor {
        let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(color & 0x0000FF) / 255.0
        return NSColor(red:r,green:g,blue:b,alpha:alpha)
    }
}
