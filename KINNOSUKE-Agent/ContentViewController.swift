//
//  ContentViewController.swift
//  KINNOSUKE-Agent
//
//  Created by Takeshita Hidenori on 2016/02/25.
//  Copyright © 2016年 taketin. All rights reserved.
//

import AppKit

class ContentViewController: NSViewController {

    override func viewWillAppear() {
        super.viewWillAppear()

        Scraper.AttendanceRecord.forgottenDays { response in
            switch response {
            case .Success(let forgottonDays):
                print("ForgottonDays: \(forgottonDays)")
                if forgottonDays.count > 0 {
                    (NSApp.delegate as! AppDelegate).notification.show(
                        title: "勤怠申請漏れがあります！",
                        message: "\(WebConnection.basePath)\(WebConnection.attendancePagePath)"
                    )

                    (NSApp.delegate as! AppDelegate).changeIcon(.Warning)
                } else {
                    (NSApp.delegate as! AppDelegate).changeIcon(.Normal)
                }
                // TODO: Kanna でスクレイピングして、空の項目があれば通知してアイコンの色を変える
                // 空の条件 - 昨日までで「届け出内容」と「実働時間」が空の列
                // TODO: その後タイマーでスクレイプ & 通知（朝、昼、晩）
                // 表示項目は、何日が空かと、リンクボタン
                // 登録したかどうかがわからないので Clear ボタンを設置
                // Clear 押されたら View から削除し、アイコンの色をもとに戻す
            case .Failure(let error):
                (NSApp.delegate as! AppDelegate).notification.show(
                    title: "通信に失敗しました",
                    message: error.description
                )
            }
        }
    }

}
