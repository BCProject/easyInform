//
//  SettingsTableViewController.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/04/10.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import UIKit
import MessageUI
import Realm

struct Setting {
    static let sectionHeight: [CGFloat] = [60.0, 30.0, 30.0, 30.0]
    static let sectionTitle: [String] = ["全般","表示","サポート","デバッグ"]
    static let contentLabel:[[String]] = [["","","履歴の初期化"],["",""],["よくある質問","お問い合わせ"],["サイボウズ","データ初期化","広告非表示"]]
    static let rowAtSection: [Int] = [3, 2, 2, 3]
    static let rowHeightAtSection: CGFloat = 50.0
    static let footerHeight: CGFloat = 100.0
}

class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    // Appデリゲート
    var _ap:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let footerView: UIView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 100.0))
        let footerLabel1: UILabel = UILabel(frame: CGRectMake(0, 20, CGRectGetWidth(self.view.frame), 20))
        let footerLabel2: UILabel = UILabel(frame: CGRectMake(0, 40, CGRectGetWidth(self.view.frame), 20))
        let footerLabel3: UILabel = UILabel(frame: CGRectMake(0, 60, CGRectGetWidth(self.view.frame), 20))
        footerLabel1.textAlignment = NSTextAlignment.Center
        footerLabel1.font = UIFont.systemFontOfSize(12.0)
        footerLabel1.text = "easyInform"
        footerLabel2.textAlignment = NSTextAlignment.Center
        footerLabel2.font = UIFont.systemFontOfSize(12.0)
        footerLabel2.text = "Copyright (c) 2015年 Brainchild Inc."
        footerLabel3.textAlignment = NSTextAlignment.Center
        footerLabel3.font = UIFont.systemFontOfSize(12.0)
        footerLabel3.text = "All rights reserved."
        footerView.addSubview(footerLabel1)
        footerView.addSubview(footerLabel2)
        footerView.addSubview(footerLabel3)
        self.tableView.tableFooterView = footerView
        
        // ****************************************//
        // For Debug...
        if (!self._ap.hideBanner) {
            self.canDisplayBannerAds = true
        } else {
            self.canDisplayBannerAds = false
        }
        // ****************************************//
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Setting.sectionHeight.count
    }
    
    // セクションタイトル
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Setting.sectionTitle[section]
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return Setting.rowAtSection[section]
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Setting.sectionHeight[section]
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Setting.rowHeightAtSection
    }
    
    // テーブルセル 内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
            case 0:
                // セルを定義
                var cell = tableView.dequeueReusableCellWithIdentifier("disclosureCell") as UITableViewCell
                let label = cell.viewWithTag(1) as UILabel
                label.text = Setting.contentLabel[indexPath.section][indexPath.row]
                return cell
            case 1:
                // セルを定義
                var cell = tableView.dequeueReusableCellWithIdentifier("disclosureCell") as UITableViewCell
                let label = cell.viewWithTag(1) as UILabel
                label.text = Setting.contentLabel[indexPath.section][indexPath.row]
                return cell
            case 2:
                // 履歴削除
                var cell = tableView.dequeueReusableCellWithIdentifier("normalCell") as UITableViewCell
                let label = cell.viewWithTag(1) as UILabel
                label.text = Setting.contentLabel[indexPath.section][indexPath.row]
                return cell
            default:
                // セルを定義
                var cell = tableView.dequeueReusableCellWithIdentifier("normalCell") as UITableViewCell
                let label = cell.viewWithTag(1) as UILabel
                label.text = Setting.contentLabel[indexPath.section][indexPath.row]
                return cell
            }
        case 1:
            switch (indexPath.row) {
            case 0:
                // セルを定義
                var cell = tableView.dequeueReusableCellWithIdentifier("disclosureCell") as UITableViewCell
                let label = cell.viewWithTag(1) as UILabel
                label.text = Setting.contentLabel[indexPath.section][indexPath.row]
                return cell
            case 1:
                // セルを定義
                var cell = tableView.dequeueReusableCellWithIdentifier("disclosureCell") as UITableViewCell
                let label = cell.viewWithTag(1) as UILabel
                label.text = Setting.contentLabel[indexPath.section][indexPath.row]
                return cell
            default:
                // セルを定義
                var cell = tableView.dequeueReusableCellWithIdentifier("normalCell") as UITableViewCell
                let label = cell.viewWithTag(1) as UILabel
                label.text = Setting.contentLabel[indexPath.section][indexPath.row]
                return cell
            }
        case 2:
            switch (indexPath.row) {
            case 0:
                // よくある質問
                var cell = tableView.dequeueReusableCellWithIdentifier("infoCell") as UITableViewCell
                let label = cell.viewWithTag(1) as UILabel
                label.text = Setting.contentLabel[indexPath.section][indexPath.row]
                return cell
            case 1:
                // お問い合わせ
                var cell = tableView.dequeueReusableCellWithIdentifier("infoCell") as UITableViewCell
                let label = cell.viewWithTag(1) as UILabel
                label.text = Setting.contentLabel[indexPath.section][indexPath.row]
                return cell
            default:
                // セルを定義
                var cell = tableView.dequeueReusableCellWithIdentifier("normalCell") as UITableViewCell
                let label = cell.viewWithTag(1) as UILabel
                label.text = Setting.contentLabel[indexPath.section][indexPath.row]
                return cell
            }
        case 3:
            switch (indexPath.row) {
            case 0:
                // セルを定義
                var cell = tableView.dequeueReusableCellWithIdentifier("infoCell") as UITableViewCell
                let label = cell.viewWithTag(1) as UILabel
                label.text = Setting.contentLabel[indexPath.section][indexPath.row]
                return cell
            case 1:
                // セルを定義
                var cell = tableView.dequeueReusableCellWithIdentifier("normalCell") as UITableViewCell
                let label = cell.viewWithTag(1) as UILabel
                label.text = Setting.contentLabel[indexPath.section][indexPath.row]
                return cell
            case 2:
                // セルを定義
                var cell = tableView.dequeueReusableCellWithIdentifier("toggleCell") as UITableViewCell
                let label = cell.viewWithTag(1) as UILabel
                label.text = Setting.contentLabel[indexPath.section][indexPath.row]
                
                let toggle = cell.viewWithTag(2) as UISwitch
                toggle.setOn(self._ap.hideBanner, animated: true)
                toggle.addTarget(self, action: "switchToggle", forControlEvents: UIControlEvents.TouchUpInside)
                return cell
            default:
                // セルを定義
                var cell = tableView.dequeueReusableCellWithIdentifier("normalCell") as UITableViewCell
                let label = cell.viewWithTag(1) as UILabel
                label.text = ""
                return cell
            }
        default:
            // セルを定義
            var cell = tableView.dequeueReusableCellWithIdentifier("normalCell") as UITableViewCell
            let label = cell.viewWithTag(1) as UILabel
            label.text = ""
            return cell
        }
    }
    
    // Cell 選択イベント
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch (Setting.contentLabel[indexPath.section][indexPath.row]) {
        case Setting.contentLabel[0][2]:
            let okAction = UIAlertAction(title: "OK", style: .Default) {action -> Void in
                if (SendHistory.deleteAllSendHistory()){
                    ViewCommon.confirmDiarog(self, msg: "履歴の初期化が完了しました", okAction: nil)
                }
                return
            }
            ViewCommon.confirmDiarog(self, msg: "履歴の初期化を行います。\nよろしいですか？", okAction: okAction, cancelAction: nil)
            break
        case Setting.contentLabel[2][0]:
            let url = NSURL(string:"http://www.brainchild.co.jp")
            let app:UIApplication = UIApplication.sharedApplication()
            app.openURL(url!)
            break
        case Setting.contentLabel[2][1]:
            // メールコントローラー定義
            let mailController = MFMailComposeViewController()
            
            // メーラーに情報を転送するためのオブジェクト
            mailController.mailComposeDelegate = self
            mailController.setToRecipients(["ryouhei_saoo@brainchild.co.jp"])
            mailController.setSubject("【easyInform】お問い合わせ")
            mailController.setMessageBody("", isHTML: false)
            
            // メール送信画面へ遷移
            self.presentViewController(mailController, animated: true, completion: nil)
            break
        case Setting.contentLabel[3][0]:
            let url = NSURL(string:"http://www.brainchild.co.jp/cb9/ag.cgi")
            let app:UIApplication = UIApplication.sharedApplication()
            app.openURL(url!)
            break
        case Setting.contentLabel[3][1]:
            let okAction = UIAlertAction(title: "OK", style: .Default) {action -> Void in
                NSFileManager.defaultManager().removeItemAtPath(RLMRealm.defaultRealmPath(), error: nil)
                ViewCommon.confirmDiarog(self, msg: "データの初期化が完了しました\nアプリケーションを再起動してください", okAction: nil)
                return
            }
            ViewCommon.confirmDiarog(self, msg: "データを初期化します。\nよろしいですか？", okAction: okAction, cancelAction: nil)
            break
        default:
            break
        }
        // 選択解除
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func switchToggle() {
        if (self._ap.hideBanner) {
            self._ap.hideBanner = false
            self.canDisplayBannerAds = true
        } else {
            self._ap.hideBanner = true
            self.canDisplayBannerAds = false
        }
    }
    
    // メール作成 終了処理
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        
        switch result.value {
        case MFMailComposeResultCancelled.value:
            println("Email Send Cancelled")
            break
        case MFMailComposeResultSaved.value:
            println("Email Saved as a Draft")
            break
        case MFMailComposeResultSent.value:
            break
        case MFMailComposeResultFailed.value:
            println("Email Send Failed")
            break
        default:
            break
        }
        
        // 設定画面に戻る
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
