//
//  WebConnection.swift
//  KINNOSUKE-Agent
//
//  Created by Takeshita Hidenori on 2016/02/21.
//  Copyright © 2016年 taketin. All rights reserved.
//

import Cocoa
import Alamofire

class WebConnection {

    // MARK: Constants

    static let userParamsKey = "KINNOSUKE-Agent_user_params"

    // MARK: Properties

    static var basePath = "\(TARGET_SITE_SCHEME)\(TARGET_SITE_URL)"

    // MARK: Enums

    enum LoginParameters: String {
        case CompanyID = "y_companycd"
        case UserID = "y_logincd"
        case Password = "password"

        static func build(companyId companyId: String, userId: String, password: String) -> [String: String] {
            let params = [
                CompanyID.rawValue: companyId,
                UserID.rawValue: userId,
                Password.rawValue: password
            ]

            return params
        }
    }

    // MARK: Cookie and User parameters

    class func storeUserData(userParams: [String: String]) {
        let userParamsData = NSKeyedArchiver.archivedDataWithRootObject(userParams)
        NSUserDefaults.standardUserDefaults().setObject(userParamsData, forKey: WebConnection.userParamsKey)
    }

    class func setCookie(response: NSHTTPURLResponse) -> Bool {
        let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(
            response.allHeaderFields as! [String: String],
            forURL: response.URL!
        )

        cookies.forEach {
            print($0)
            NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie($0)
        }

        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfiguration.HTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()

        _ = Alamofire.Manager(configuration: sessionConfiguration)
        
        return true
    }

    // MARK: Requests

    /**
     * NOTE: Params have 3 parameters
     *  (company id, user id, password)
     */
    class func login(params: [String: String], completion: Result<NSHTTPURLResponse, NSError> -> ()) {
        let isLoginedKeyString = "ログアウト"

        Alamofire.request(.POST, WebConnection.basePath, parameters: params).responseString { response in
            print("Request: \(WebConnection.basePath)")
            switch response.result {
            case .Success(let value):
                if let response = response.response,
                   let _ = value.rangeOfString(isLoginedKeyString)
                   where setCookie(response)
                {
                    storeUserData(params)
                    completion(.Success(response))
                } else {
                    completion(.Failure(NSError(domain: "login", code: 1000, userInfo: nil)))
                }

            case .Failure(let error):
                completion(.Failure(error))
            }
        }
    }

    class func loginSession(completion: Result<NSHTTPURLResponse, NSError> -> ()) {
        guard let userParamsData = NSUserDefaults.standardUserDefaults().objectForKey(WebConnection.userParamsKey) as? NSData,
              let userParams = NSKeyedUnarchiver.unarchiveObjectWithData(userParamsData) as? [String: String]
        else {
            return completion(.Failure(NSError(domain: "login-session", code: 1000, userInfo: nil)))
        }

        WebConnection.login(userParams) { response in
            switch response {
            case .Success(let res):
                print("Login-session succeeded.")
                completion(.Success(res))

            case .Failure:
                print("Login-session failure.")
                (NSApp.delegate as! AppDelegate).notification.show(
                    title: "Failed login to 勤乃助",
                    message: "Check your input informations."
                )
            }
        }
    }

    class func attendanceRecord(completion: Result<NSHTTPURLResponse, NSError> -> ()) {
        loginSession { response in
            switch response {
            case .Success:
                let params = [
                    "module": "timesheet",
                    "action": "browse"
                ]

                Alamofire.request(.GET, "\(WebConnection.basePath)", parameters: params).responseString { response in
                    switch response.result {
                    case .Success:
                        completion(.Success(response.response!))

                    case .Failure(let error):
                        completion(.Failure(error))
                    }
                }
            case .Failure(let error):
                completion(.Failure(error))
            }
        }
    }

}