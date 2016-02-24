//
//  NSUserDefaults+Extensions.swift
//  KINNOSUKE-Agent
//
//  Created by Takeshita Hidenori on 2016/02/25.
//  Copyright © 2016年 taketin. All rights reserved.
//

import Foundation

extension NSUserDefaults {
    typealias USER_PARAMS = [String: String]
    @nonobjc static let userParamsKey = "KINNOSUKE-Agent_user_params"

    class func storeUserData(userParams: USER_PARAMS) {
        let userParamsData = NSKeyedArchiver.archivedDataWithRootObject(userParams)
        NSUserDefaults.standardUserDefaults().setObject(userParamsData, forKey: NSUserDefaults.userParamsKey)
    }

    class func userParams() -> USER_PARAMS? {
        guard let userParamsData = NSUserDefaults.standardUserDefaults().objectForKey(NSUserDefaults.userParamsKey) as? NSData,
              let userParams = NSKeyedUnarchiver.unarchiveObjectWithData(userParamsData) as? USER_PARAMS
        else {
            return nil
        }

        return userParams
    }
}