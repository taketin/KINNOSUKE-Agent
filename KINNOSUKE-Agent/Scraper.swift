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

class Scraper {

    typealias Day = String

    // MARK: Class methods

    class func filter(strings: String) -> String {
        return strings.stringByReplacingOccurrencesOfString("\t", withString: "")
                      .stringByReplacingOccurrencesOfString("\n", withString: "")
                      .stringByReplacingOccurrencesOfString("&nbsp;", withString: "")
    }

    // MARK: Sub classes

    struct AttendanceRecord {

        enum ForgottenPoint: Int {
            case None = 0, Todokede = 1, Jitsudou = 2, Forgot = 3
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

        static func forgottenDays(completion: (Result<[Day], NSError> -> ())?) {

            WebConnection.attendanceRecord { response in
                switch response {
                case .Success(let htmlString):
                    print("Attendance record succeeded.")

                    let dateComponent = NSDate.componentsByDate()
                    var forgottonDays = [Day]()
                    let filteredHtmlString = Scraper.filter(htmlString)

                    let doc = HTML(html: filteredHtmlString, encoding: NSUTF8StringEncoding)

                    CheckTable: for (_, nodeByTr) in doc!.body!.css(scrapeElement).enumerate() {
                        var status = ForgottenPoint.None.rawValue
                        var day = ""

                        for (indexByTd, nodeByTd) in nodeByTr.css("td").enumerate() {
                            switch indexByTd {
                            case dayColumnIndex:
                                day = nodeByTd.text!
                                if day == skipContent {
                                    continue CheckTable
                                } else if day == finishContent || Int(day) >= Int(dateComponent.day) {
                                    break CheckTable
                                }
                                print("日: \(day)")

                            // NOTE: Check to カレンダー
                            case typeOfDayIndex:
                                print("カレンダー: \(nodeByTd.text!)")
                                if nodeByTd.text! != dayOfNormal {
                                    continue CheckTable
                                }

                            // NOTE: Check to 届け出内容
                            case todokedeNaiyouColumnIndex:
                                print("届出: \(nodeByTd.text!)")
                                if nodeByTd.text! == "" {
                                    status += ForgottenPoint.Todokede.rawValue
                                }

                            // NOTE: Check to 実働時間
                            case jitsudouJikanColumnIndex:
                                print("実働: \(nodeByTd.text!)")
                                if nodeByTd.text! == "" {
                                    status += ForgottenPoint.Jitsudou.rawValue
                                }
                            default:
                                break
                            }
                        }

                        if status == ForgottenPoint.Forgot.rawValue {
                            forgottonDays.append(day)
                        }
                    }

                    if let completion = completion {
                        completion(.Success(forgottonDays))
                    }

                case .Failure(let error):
                    print("Login failure.")
                    if let completion = completion {
                        completion(.Failure(error))
                    }
                }

            }
        }
    }

}
