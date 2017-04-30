//
//  Scraper.swift
//  KINNOSUKE-Agent
//
//  Created by Takeshita Hidenori on 2016/02/27.
//  Copyright © 2016年 taketin. All rights reserved.
//

import AppKit
import Alamofire
import Kanna
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class Scraper {

    typealias Day = String

    // MARK: Class methods

    class func filter(_ strings: String) -> String {
        return strings.replacingOccurrences(of: "\t", with: "")
                      .replacingOccurrences(of: "\n", with: "")
                      .replacingOccurrences(of: "&nbsp;", with: "")
    }

    // MARK: Sub classes

    struct AttendanceRecord {

        enum ForgottenPoint: Int {
            case none = 0, todokede = 1, jitsudou = 2, forgot = 3
        }

        // MARK: Static properties

        static let scrapeElement = "table.txt_12 tr"
        static let skipContent = "日"
        static let finishContent = "合計"
        static let dayOfNormal = "平日"
        static let dayColumnIndex = 0
        static let typeOfDayIndex = 2
        static let todokedeNaiyouColumnIndex = 4
        static let jitsudouJikanColumnIndex = 8

        // MARK: Static methods

        static func forgottenDays(_ completion: ((Result<[Day]>) -> ())?) {

            WebConnection.attendanceRecord { response in
                switch response {
                case .success(let htmlString):
                    let dateComponent = Date.componentsByDate()
                    var forgottonDays = [Day]()
                    let filteredHtmlString = Scraper.filter(htmlString)

                    let doc = HTML(html: filteredHtmlString, encoding: String.Encoding.utf8)

                    CheckTable: for (_, nodeByTr) in doc!.body!.css(scrapeElement).enumerated() {
                        var status = ForgottenPoint.none.rawValue
                        var day = ""

                        for (indexByTd, nodeByTd) in nodeByTr.css("td").enumerated() {
                            switch indexByTd {
                            case dayColumnIndex:
                                day = nodeByTd.text!
                                if day == skipContent {
                                    continue CheckTable
                                } else if day == finishContent || Int(day) >= Int(dateComponent.day!) {
                                    break CheckTable
                                }

                            // NOTE: Check to カレンダー
                            case typeOfDayIndex:
                                if nodeByTd.text! != dayOfNormal {
                                    continue CheckTable
                                }

                            // NOTE: Check to 届け出内容
                            case todokedeNaiyouColumnIndex:
                                if nodeByTd.text! == "" {
                                    status += ForgottenPoint.todokede.rawValue
                                }

                            // NOTE: Check to 実働時間
                            case jitsudouJikanColumnIndex:
                                if nodeByTd.text! == "" {
                                    status += ForgottenPoint.jitsudou.rawValue
                                }
                            default:
                                break
                            }
                        }

                        if status == ForgottenPoint.forgot.rawValue {
                            forgottonDays.append(day)
                        }
                    }

                    if let completion = completion {
                        completion(.success(forgottonDays))
                    }

                case .failure(let error):
                    if let completion = completion {
                        completion(.failure(error))
                    }
                }

            }
        }
    }

}
