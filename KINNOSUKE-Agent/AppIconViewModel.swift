//
//  AppIconViewModel.swift
//  KINNOSUKE-Agent
//
//  Created by Takeshita Hidenori on 2016/08/28.
//  Copyright © 2016年 taketin. All rights reserved.
//

import AppKit
import RxSwift

class AppIconViewModel {

    // MARK: Enums

    enum State {
        case Normal, Warning
    }

    enum Color: String {
        case Black = "icon_kinnosuke_black"
        case White = "icon_kinnosuke_white"
        case Red = "icon_kinnosuke_red"
    }

    // MARK: Constants

    private let iconImageVar = Variable(NSImage(named: AppIconViewModel.normalColor.rawValue)!)

    // MARK: Properties

    class var normalColor: Color {
        switch AppDelegate.interfaceStyle() {
        case .Light: return .Black
        case .Dark: return .White
        }
    }

    var iconImage: Observable<NSImage> {
        return iconImageVar.asObservable()
    }

    // MARK: Methods

    func change(state state: State) {
        let color: Color

        switch state {
        case .Normal: color = AppIconViewModel.normalColor
        case .Warning: color = .Red
        }

        iconImageVar.value = NSImage(named: color.rawValue)!
    }

}