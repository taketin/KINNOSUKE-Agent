//
//  NSUserDefaults+Extensions.swift
//  KINNOSUKE-Agent
//
//  Created by Takeshita Hidenori on 2016/02/25.
//  Copyright © 2016年 taketin. All rights reserved.
//

import Foundation

extension UserDefaults {
    typealias USER_PARAMS = [String: String]
    @nonobjc static let userParamsKey = "KINNOSUKE-Agent_user_params"

    // MARK: Class methods

    class func storeUserData(_ userParams: USER_PARAMS) {
        let userParamsData = NSKeyedArchiver.archivedData(withRootObject: userParams)
        UserDefaults.standard.set(userParamsData, forKey: UserDefaults.userParamsKey)
    }

    class func userParams() -> USER_PARAMS? {
        guard let userParamsData = UserDefaults.standard.object(forKey: UserDefaults.userParamsKey) as? Data,
              let userParams = NSKeyedUnarchiver.unarchiveObject(with: userParamsData) as? USER_PARAMS
        else {
            return nil
        }

        return userParams
    }

    class func deleteUserParams() {
        UserDefaults.standard.removeObject(forKey: UserDefaults.userParamsKey)
    }
}
