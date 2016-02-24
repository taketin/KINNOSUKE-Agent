//
//  ContentViewController.swift
//  KINNOSUKE-Agent
//
//  Created by Takeshita Hidenori on 2016/02/25.
//  Copyright © 2016年 taketin. All rights reserved.
//

import Cocoa

class ContentViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        WebConnection.attendanceRecord { response in
            switch response {
            case .Success(let res):
                print("Attendance record succeeded.")


            case .Failure:
                print("Login failure.")
                (NSApp.delegate as! AppDelegate).notification.show(
                    title: "Attendance record failure",
                    message: ""
                )
            }
        }
    }

}
