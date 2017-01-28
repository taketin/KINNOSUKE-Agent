//
//  AppDelegate.swift
//  KINNOSUKE-Agent
//
//  Created by Takeshita Hidenori on 2016/02/12.
//  Copyright © 2016年 taketin. All rights reserved.
//

import AppKit
import RxSwift

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    // MARK: Enums

    enum InterfaceStyle {
        case Light, Dark
    }

    // MARK: IBOutlets

    @IBOutlet weak var _statusMenu: NSMenu!

    // MARK: Constants

    private let disposeBag = DisposeBag()

    // MARK: Properties

    var statusButton: CustomMenuButton!
    var statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    var loginViewController: LoginViewController
    var appIconViewModel = AppIconViewModel()
    var popover = NSPopover()
    var notification = Notification()
    var timer: NSTimer!

    // MARK: Initializer

    override init() {
        loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)!
        popover.contentViewController = loginViewController
    }

    // MARK: Lifecycle

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        configureStatusItem()

        // NOTE: Set the timer for regularly check.
        timer = NSTimer(fireDate: NSDate(), interval: PATROL_INTERVAL_SEC, target: self, selector: "patrol:", userInfo: false, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }

    func configureStatusItem() {
        statusItem.highlightMode = true

        if let _ = NSUserDefaults.userParams() {
            statusItem.view = nil
            statusItem.menu = _statusMenu
        } else {
            statusButton = CustomMenuButton(frame: CGRect(x: 0,y: 0, width: 18, height: 18))
            statusButton.bordered = false
            statusButton.target = self
            statusButton.rightMouseDownAction = { _ in }
            statusButton.action = "togglePopover:"
            statusItem.view = statusButton
        }

        appIconViewModel.iconImage.subscribeNext { [unowned self] image in
            self.statusItem.image = image
        }.addDisposableTo(disposeBag)
    }

    deinit {
        timer.invalidate()
        timer = nil
    }

    // MARK: Action methods

    func togglePopover(sender: AnyObject?) {
        if let _ = NSUserDefaults.userParams() {
            configureStatusItem()
        } else {
            if popover.shown {
                closePopover(sender)
            } else {
                showPopover(sender)
            }
        }
    }

    func patrol(timer: NSTimer) {
        guard let userInfo = timer.userInfo as? Bool,
              let _ = NSUserDefaults.userParams()
        else {
            return
        }

        patrol(notifyImmediately: userInfo)
    }

    // MARK: Public methods

    func patrol(notifyImmediately notifyImmediately: Bool = false) {
        Scraper.AttendanceRecord.forgottenDays { [weak self] response in
            guard let strongSelf = self else {
                return
            }

            switch response {
            case .Success(let forgottonDays):
                let iconState: AppIconViewModel.State
                if forgottonDays.count > 0 {
                    if notifyImmediately || NSDate.isNotificationTime() {
                        (NSApp.delegate as! AppDelegate).notification.show(
                            title: "勤怠申請漏れが\(forgottonDays.count)件あります！",
                            message: "\(WebConnection.basePath)\(WebConnection.attendancePagePath)"
                        )
                    }

                    iconState = .Warning
                } else {
                    if notifyImmediately {
                        (NSApp.delegate as! AppDelegate).notification.show(
                            title: "勤怠申請漏れはありません",
                            message: "\(WebConnection.basePath)\(WebConnection.attendancePagePath)"
                        )
                    }

                    iconState = .Normal
                }

                strongSelf.appIconViewModel.change(state: iconState)

            case .Failure(let error):
                (NSApp.delegate as! AppDelegate).notification.show(
                    title: "通信に失敗しました",
                    message: error.description
                )
            }
        }
    }

    func showPopover(sender: AnyObject?) {
        popover.showRelativeToRect(statusButton.bounds, ofView: statusButton, preferredEdge: .MinY)
    }

    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
    }

    // MARK: Static methods

    static func interfaceStyle() -> InterfaceStyle {
        if let domain = NSUserDefaults.standardUserDefaults().persistentDomainForName(NSGlobalDomain) {
            if let style = domain["AppleInterfaceStyle"] as? String {
                return style == "Dark" ? .Dark : .Light
            }
        }

        return .Light
    }
}

extension AppDelegate: NSMenuDelegate {
    func menuWillOpen(menu: NSMenu) {
        // MEMO: If user defaults cleanup, will the menu change.
        configureStatusItem()
    }

    @IBAction func fetch(sender: AnyObject) {
        patrol(notifyImmediately: true)
    }

    @IBAction func logout(sender: AnyObject) {
        NSUserDefaults.deleteUserParams()
    }
}