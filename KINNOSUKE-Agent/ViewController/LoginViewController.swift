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

    @IBOutlet weak fileprivate var _titleContainer: NSView!
    @IBOutlet weak fileprivate var _companyIdForm: NSTextField!
    @IBOutlet weak fileprivate var _userIdForm: NSTextField!
    @IBOutlet weak fileprivate var _passwordForm: NSTextField!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let titleViewLayer = CALayer()
        titleViewLayer.backgroundColor = NSColor.hex(0x963121).cgColor
        _titleContainer.wantsLayer = true
        _titleContainer.layer = titleViewLayer

    }

    // MARK: Action methods

    @IBAction func didTouchLoginButton(_ sender: AnyObject) {
        let params = WebConnection.LoginParameters.build(
            companyId: _companyIdForm.stringValue,
            userId: _userIdForm.stringValue,
            password: _passwordForm.stringValue
        )

        WebConnection.login(params) { response in
            switch response {
            case .success:
                (NSApp.delegate as! AppDelegate).notification.show(
                    title: "Succeed !",
                    message: "Login to your 勤之助"
                )

                let appDelegate = (NSApp.delegate as! AppDelegate)
                appDelegate.closePopover(nil)
                appDelegate.configureStatusItem()

            case .failure(let error):
                (NSApp.delegate as! AppDelegate).notification.show(
                    title: "Failed login to 勤之助",
                    message: error.description
                )
            }
        }

    }

}
