# KINNOSUKE-Agent <img width="26" alt="2016-02-28 22 53 03" src="https://cloud.githubusercontent.com/assets/71396/13423044/ffc672e2-dfdb-11e5-8f98-604b13246af6.png">
A unofficial tool of KINNOSUKE notifier for mac OS X.

Current βversion.

## これは何

勤怠管理 ASP 「勤之助（万屋一家）」を便利に扱う Mac OS X 用ステータスバー常駐型アプリです。

## 使い方

- インストール後、アプリを起動すると Mac のステータスバーにアプリが常駐します。
- クリックするとログインフォームが現れますので、あなたの情報を入力してください。
    - ※アカウント情報はアプリが保持しています。ログアウト、もしくはアプリ削除時に一緒に削除しますので安心してください。
- ログインすると、クリックした時のメニューが変わります。
    - `Fetch`:  勤之助の勤怠ページから、現在月の昨日までの申請していない日があれば通知してくれます。
    - `Logout`: 勤之亮のログイン情報を消去します。
    - `Quit`: アプリを終了します。
- 起動している間は約2時間おきに前日までの勤怠申請漏れをチェックして、漏れがあれば朝、夕（だいたい）に通知します。
- 漏れがあるとアイコンが赤くなります。その後の fetch で漏れが無くなっていれば色は元に戻ります。

## Tips

- `システム環境設定 > ユーザとグループ > ログイン項目` に `KINNOSUKE-Agent` を追加しておくと便利です。

## Licence

KINNOSUKE-Agent is released under the MIT license.
