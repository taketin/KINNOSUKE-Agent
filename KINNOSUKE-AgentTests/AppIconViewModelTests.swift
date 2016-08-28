//
//  AppIconViewModelTests.swift
//  KINNOSUKE-Agent
//
//  Created by Takeshita Hidenori on 2016/08/28.
//  Copyright © 2016年 taketin. All rights reserved.
//

import AppKit
import XCTest
import RxSwift

@testable import KINNOSUKE_Agent

class AppIconViewModelTests: XCTestCase {

    var image = NSImage()
    let viewModel = AppIconViewModel()
    let disposeBag = DisposeBag()

    override func setUp() {
        super.setUp()
        viewModel.iconImage.subscribeNext { [unowned self] image in
            self.image = image
        }.addDisposableTo(disposeBag)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testChange() {
        let blackImage = NSImage(named: AppIconViewModel.Color.Black.rawValue)!
        let whiteImage = NSImage(named: AppIconViewModel.Color.White.rawValue)!
        let redImage = NSImage(named: AppIconViewModel.Color.Red.rawValue)!

        if let domain = NSUserDefaults.standardUserDefaults().persistentDomainForName(NSGlobalDomain) {
            if let style = domain["AppleInterfaceStyle"] as? String where style == "Dark" {
                XCTAssertEqual(image, whiteImage)
            } else {
                XCTAssertEqual(image, blackImage)
            }
        }
        viewModel.change(state: .Warning)
        XCTAssertEqual(image, redImage)
    }
    
}
