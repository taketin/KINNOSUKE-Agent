//
//  Notification.swift
//  KINNOSUKE-Agent
//
//  Created by Takeshita Hidenori on 2016/02/21.
//  Copyright © 2016年 taketin. All rights reserved.
//

import AppKit

class Notification: NSObject {
    private var _center: NSUserNotificationCenter

    // MARK: Iitializer

    override init() {
        _center = NSUserNotificationCenter.defaultUserNotificationCenter()
        super.init()
        _center.delegate = self
    }

    // MARK: Public methods

    func show(title title: String, message: String) {
        let notification = NSUserNotification()
        notification.title = title
        notification.informativeText = message

        _center.deliverNotification(notification)
    }
}

extension Notification: NSUserNotificationCenterDelegate {
    func userNotificationCenter(center: NSUserNotificationCenter, shouldPresentNotification notification: NSUserNotification) -> Bool {
        return true
    }

    func userNotificationCenter(center: NSUserNotificationCenter, didActivateNotification notification: NSUserNotification) {
        if let urlString = notification.informativeText,
           let url = NSURL(string: urlString)
        {
            NSWorkspace.sharedWorkspace().openURL(url)
        }
    }
}