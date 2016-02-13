//
//  AppDelegate.swift
//  KINNOSUKE-Agent
//
//  Created by Takeshita Hidenori on 2016/02/12.
//  Copyright © 2016年 taketin. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var _statusMenu: NSMenu!
    private var _statusItem: NSStatusItem?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        _setupStatusItem()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }

    private func _setupStatusItem() {
        let statusBar = NSStatusBar.systemStatusBar()
        _statusItem = statusBar.statusItemWithLength(NSVariableStatusItemLength)
        if let statusItem = _statusItem {
            statusItem.highlightMode = true
            statusItem.title = AppName
            // TODO: アイコン
            // _statusItem?.image = NSImage(named: "")
            _statusItem?.menu = _statusMenu
        }
    }
}

