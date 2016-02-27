//
//  AppDelegate.swift
//  KINNOSUKE-Agent
//
//  Created by Takeshita Hidenori on 2016/02/12.
//  Copyright © 2016年 taketin. All rights reserved.
//

import AppKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    enum IconState {
        case Normal, Warning
    }

    @IBOutlet weak var _statusMenu: NSMenu!
    var statusButton: CustomMenuButton!
    var statusItem: NSStatusItem?
    var loginViewController: LoginViewController
    var contentViewController: ContentViewController
    var popover: NSPopover
    var notification = Notification()

    override init() {
        loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)!
        contentViewController = ContentViewController(nibName: "ContentViewController", bundle: nil)!
        popover = NSPopover()
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        _setupStatusItem()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }

    private func _setupStatusItem() {
        statusButton = CustomMenuButton(frame: CGRect(x: 0,y: 0, width: 20, height: 20))
        statusButton.title = AppName
        statusButton.bordered = false
        statusButton.target = self
        statusButton.action = "togglePopover:"
        statusButton.rightMouseDownAction = { _ in }
        statusButton.image = NSImage(named: "kinnosuke_white")

        // NOTE: Setting icon
        changeIcon(.Normal)
        statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
        if let statusItem = statusItem {
            statusItem.highlightMode = true
            statusItem.title = AppName
            statusItem.view = statusButton
        }
    }

    // MARK: Action methods

    func togglePopover(sender: AnyObject?) {
        if let _ = NSUserDefaults.userParams() {
            popover.contentViewController = contentViewController
        } else {
            popover.contentViewController = loginViewController
        }

        if popover.shown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }

    // MARK: Public methods

    func changeIcon(state: IconState) {
        switch state {
        case .Normal:
            var imageName = "icon_kinnosuke"
            if let domain = NSUserDefaults.standardUserDefaults().persistentDomainForName(NSGlobalDomain) {
                if let style = domain["AppleInterfaceStyle"] as? String {
                    if style == "Dark" {
                        imageName += "_white"
                    } else {
                        imageName += "_black"
                    }
                }
            }

            self.statusButton.image = NSImage(named: imageName)

        case .Warning:
            self.statusButton.image = NSImage(named: "icon_kinnosuke_red")
        }
    }

    func showPopover(sender: AnyObject?) {
        popover.showRelativeToRect(statusButton.bounds, ofView: statusButton, preferredEdge: .MinY)
    }

    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
    }

}
