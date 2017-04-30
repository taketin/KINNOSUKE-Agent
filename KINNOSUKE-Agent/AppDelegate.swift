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
        case normal, warning
    }

    // MARK: IBOutlets

    @IBOutlet weak var _statusMenu: NSMenu!

    // MARK: Properties

    var statusButton: CustomMenuButton!
    var statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    var loginViewController: LoginViewController
    var popover = NSPopover()
    var notification = Notification()
    var timer: Timer!

    // MARK: Initializer

    override init() {
        loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)!
        popover.contentViewController = loginViewController
    }

    // MARK: Lifecycle

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        configureStatusItem()

        // NOTE: Set the timer for regularly check.
        timer = Timer(fireAt: Date(), interval: PATROL_INTERVAL_SEC, target: self, selector: "patrol:", userInfo: false, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

    func configureStatusItem() {
        statusItem.highlightMode = true

        if let _ = UserDefaults.userParams() {
            statusItem.view = nil
            statusItem.image = iconImage(.normal)
            statusItem.menu = _statusMenu
        } else {
            statusButton = CustomMenuButton(frame: CGRect(x: 0,y: 0, width: 18, height: 18))
            statusButton.image = iconImage(.normal)
            statusButton.isBordered = false
            statusButton.target = self
            statusButton.rightMouseDownAction = { _ in }
            statusButton.action = #selector(AppDelegate.togglePopover(_:))
            statusItem.view = statusButton
        }
    }

    deinit {
        timer.invalidate()
        timer = nil
    }

    // MARK: Action methods

    func togglePopover(_ sender: AnyObject?) {
        if let _ = UserDefaults.userParams() {
            configureStatusItem()
        } else {
            if popover.isShown {
                closePopover(sender)
            } else {
                showPopover(sender)
            }
        }
    }

    func patrol(_ timer: Timer) {
        guard let userInfo = timer.userInfo as? Bool,
              let _ = UserDefaults.userParams()
        else {
            return
        }

        patrol(notifyImmediately: userInfo)
    }

    // MARK: Public methods

    func patrol(notifyImmediately: Bool = false) {
        Scraper.AttendanceRecord.forgottenDays { [weak self] response in
            guard let strongSelf = self else {
                return
            }

            switch response {
            case .success(let forgottonDays):
                if forgottonDays.count > 0 {
                    if notifyImmediately || Date.isNotificationTime() {
                        (NSApp.delegate as! AppDelegate).notification.show(
                            title: "勤怠申請漏れが\(forgottonDays.count)件あります！",
                            message: "\(WebConnection.basePath)\(WebConnection.attendancePagePath)"
                        )
                    }

                    strongSelf.statusItem.image = strongSelf.iconImage(.warning)
                } else {
                    if notifyImmediately {
                        (NSApp.delegate as! AppDelegate).notification.show(
                            title: "勤怠申請漏れはありません",
                            message: "\(WebConnection.basePath)\(WebConnection.attendancePagePath)"
                        )
                    }
                    strongSelf.statusItem.image = strongSelf.iconImage(.normal)
                }

            case .failure(let error):
                (NSApp.delegate as! AppDelegate).notification.show(
                    title: "通信に失敗しました",
                    message: error.localizedDescription
                )
            }
        }
    }

    func iconImage(_ state: IconState) -> NSImage {
        switch state {
        case .normal:
            var imageName = "icon_kinnosuke_black"
            if let domain = UserDefaults.standard.persistentDomain(forName: UserDefaults.globalDomain) {
                if let style = domain["AppleInterfaceStyle"] as? String {
                    if style == "Dark" {
                        imageName = "icon_kinnosuke_white"
                    }
                }
            }

            return NSImage(named: imageName)!

        case .warning:
            return NSImage(named: "icon_kinnosuke_red")!
        }
    }

    func showPopover(_ sender: AnyObject?) {
        popover.show(relativeTo: statusButton.bounds, of: statusButton, preferredEdge: .minY)
    }

    func closePopover(_ sender: AnyObject?) {
        popover.performClose(sender)
    }

}

extension AppDelegate: NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        // MEMO: If user defaults cleanup, will the menu change.
        configureStatusItem()
    }

    @IBAction func fetch(_ sender: AnyObject) {
        patrol(notifyImmediately: true)
    }

    @IBAction func logout(_ sender: AnyObject) {
        UserDefaults.deleteUserParams()
    }
}
