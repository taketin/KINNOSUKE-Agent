//
//  LoginViewController.swift
//  KINNOSUKE-Agent
//
//  Created by Takeshita Hidenori on 2016/02/14.
//  Copyright © 2016年 taketin. All rights reserved.
//

import AppKit

class LoginViewController: NSViewController {

    // MARK: IBOutlets

    @IBOutlet weak private var _titleContainer: NSView!
    @IBOutlet weak private var _companyIdForm: NSTextField!
    @IBOutlet weak private var _userIdForm: NSTextField!
    @IBOutlet weak private var _passwordForm: NSTextField!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let titleViewLayer = CALayer()
        titleViewLayer.backgroundColor = NSColor.hex(0x963121).CGColor
        _titleContainer.wantsLayer = true
        _titleContainer.layer = titleViewLayer

    }

    // MARK: Action methods

    @IBAction func didTouchLoginButton(sender: AnyObject) {
        let params = WebConnection.LoginParameters.build(
            companyId: _companyIdForm.stringValue,
            userId: _userIdForm.stringValue,
            password: _passwordForm.stringValue
        )

        WebConnection.login(params) { response in
            switch response {
            case .Success:
                print("Login succeeded.")
                (NSApp.delegate as! AppDelegate).notification.show(
                    title: "Succeed !",
                    message: "Login to your 勤乃助"
                )

                let appDelegate = (NSApp.delegate as! AppDelegate)
                appDelegate.popover.contentViewController = appDelegate.contentViewController
                appDelegate.showPopover(nil)

            case .Failure:
                print("Login failure.")
                (NSApp.delegate as! AppDelegate).notification.show(
                    title: "Failed login to 勤乃助",
                    message: "Check your input informations."
                )
            }
        }

    }

}
