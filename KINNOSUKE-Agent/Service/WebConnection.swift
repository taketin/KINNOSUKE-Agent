//
//  WebConnection.swift
//  KINNOSUKE-Agent
//
//  Created by Takeshita Hidenori on 2016/02/21.
//  Copyright © 2016年 taketin. All rights reserved.
//

import AppKit
import Alamofire

class WebConnection {

    typealias HTML = String

    // MARK: Properties

    static let attendancePagePath = "?module=timesheet&action=browse"

    // MARK: Enums

    enum LoginParameters: String {
        case CompanyID = "y_companycd"
        case UserID = "y_logincd"
        case Password = "password"

        static func build(companyId: String, userId: String, password: String, loginHost: Int) -> [String: String] {
            let loginHostString: String
            switch (loginHost) {
            case 0:
                loginHostString = "\(URL_E4628)/\(companyId)/"
            case 1:
                loginHostString = URL_4628
            default:
                loginHostString = URL_4628
            }

            let params = [
                CompanyID.rawValue: companyId,
                UserID.rawValue: userId,
                Password.rawValue: password,
                "loginhost": "\(SCHEME)\(loginHostString)"
            ]

            return params
        }
    }

    // MARK: Cookie and User parameters

    class func setCookie(_ response: HTTPURLResponse) -> Bool {
        let cookies = HTTPCookie.cookies(
            withResponseHeaderFields: response.allHeaderFields as! [String: String],
            for: response.url!
        )

        cookies.forEach {
            HTTPCookieStorage.shared.setCookie($0)
        }

        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.httpCookieStorage = HTTPCookieStorage.shared

        _ = Alamofire.SessionManager(configuration: sessionConfiguration)
        
        return true
    }

    // MARK: Requests

    /**
     * NOTE: Params has 3 parameters
     *  (company id, user id, password)
     */
    class func login(_ params: [String: String], completion: @escaping (Result<HTML>) -> ()) {
        let isLoginedKeyString = "前回ログイン"

        Alamofire.request(params["loginhost"]!, method: .post, parameters: params).responseString { response in
            switch response.result {
            case .success(let html):
                if let response = response.response,
                   let _ = html.range(of: isLoginedKeyString), setCookie(response)
                {
                    UserDefaults.storeUserData(params)
                    completion(.success(html))
                } else {
                    completion(.failure(NSError(domain: "login", code: 1000, userInfo: nil)))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    class func loginSession(_ completion: @escaping (Result<HTML>) -> ()) {
        guard let userParams = UserDefaults.userParams() else {
            return completion(.failure(NSError(domain: "login-session", code: 1000, userInfo: nil)))
        }

        WebConnection.login(userParams) { response in
            switch response {
            case .success(let html):
                completion(.success(html))

            case .failure(let error):
                (NSApp.delegate as! AppDelegate).notification.show(
                    title: "Failed login to 勤之助",
                    message: error.localizedDescription
                )
            }
        }
    }

    class func attendanceRecord(_ completion: @escaping (Result<HTML>) -> ()) {
        loginSession { response in
            switch response {
            case .success:
                // FIXME: ログイン URL はいちいち userdefaults から取るのうざいので別で持つようにしたい
                guard let userParams = UserDefaults.userParams() else {
                    return completion(.failure(NSError(domain: "attendance-record", code: 1001, userInfo: nil)))
                }

                let params = [
                    "module": "timesheet",
                    "action": "browse"
                ]

                Alamofire.request(userParams["loginhost"]!, method: .get, parameters: params).responseString { response in
                    switch response.result {
                    case .success(let html):
                        completion(.success(html))

                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
