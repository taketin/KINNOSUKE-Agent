//
//  Notification.swift
//  KINNOSUKE-Agent
//
//  Created by Takeshita Hidenori on 2016/02/21.
//  Copyright © 2016年 taketin. All rights reserved.
//

import AppKit

class Notification: NSObject {
    fileprivate var _center: NSUserNotificationCenter

    // MARK: Iitializer

    override init() {
        _center = NSUserNotificationCenter.default
        super.init()
        _center.delegate = self
    }

    // MARK: Public methods

    func show(title: String, message: String) {
        let notification = NSUserNotification()
        notification.title = title
        notification.informativeText = message

        _center.deliver(notification)
    }
}

extension Notification: NSUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        if let urlString = notification.informativeText,
           let url = URL(string: urlString)
        {
            NSWorkspace.shared().open(url)
        }
    }
}
