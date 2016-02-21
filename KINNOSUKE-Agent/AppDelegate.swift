//
//  AppDelegate.swift
//  KINNOSUKE-Agent
//
//  Created by Takeshita Hidenori on 2016/02/12.
//  Copyright © 2016年 taketin. All rights reserved.
//

import Cocoa
import Kanna

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var _statusMenu: NSMenu!
    var statusButton: CustomMenuButton!
    var statusItem: NSStatusItem?
    var loginViewController: LoginViewController
    var popover: NSPopover
    var notification = Notification()

    override init() {
        // TODO: ログイン情報を持っているかどうかでビューを出し分ける
        loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)!
        popover = NSPopover()
        popover.contentViewController = loginViewController
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        _setupStatusItem()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }

    private func _setupStatusItem() {
        statusButton = CustomMenuButton(frame: CGRect(x: 0,y: 0, width: 50, height: 30))
        statusButton.title = AppName
        statusButton.bordered = false
        statusButton.target = self
        statusButton.action = "togglePopover:"
        statusButton.rightMouseDownAction = { _ in }

        statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
        if let statusItem = statusItem {
            statusItem.highlightMode = true
            statusItem.title = AppName
            // TODO: アイコン
            // _statusItem?.image = NSImage(named: "")
            statusItem.view = statusButton
        }
    }

    // MARK: Action methods

    func togglePopover(sender: AnyObject?) {
        if popover.shown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }

    // MARK:

    func showPopover(sender: AnyObject?) {
        popover.showRelativeToRect(statusButton.bounds, ofView: statusButton, preferredEdge: .MinY)
    }

    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
    }

}
