//
//  CustomMenuButton.swift
//  KINNOSUKE-Agent
//
//  Created by Takeshita Hidenori on 2016/02/14.
//  Copyright © 2016年 taketin. All rights reserved.
//

import AppKit

class CustomMenuButton: NSButton {
    var rightMouseDownAction:((NSEvent) -> ())?

    override func rightMouseDown(with theEvent: NSEvent) {
        if let rightMouseDownAction = rightMouseDownAction {
            rightMouseDownAction(theEvent)
        }
    }
}
