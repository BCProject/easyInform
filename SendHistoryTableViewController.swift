//
//  SendHistoryTableViewController.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/13.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import UIKit
import Realm
import iAd

class SendHistoryTableViewController: UITableViewController, UISearchBarDelegate {


    @IBOutlet weak var searchBar: UISearchBar!
    
    // NotificationToken定義
    private var _notificationToken : RLMNotificationToken?
    
    var _template :String = ""
    var _searchWord :String = ""
    var _section = [String]()
    var _sectionCount :NSInteger = 0
    var _showBanner = false
    var _ap:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TemplateHead NotificationToken
        self._notificationToken = RLMRealm.defaultRealm().addNotificationBlock{ note, realm in
            self.tableView.reloadData()
        }
        
        // 検索バーDelegate
        self.searchBar.delegate = self
        self.getTextFieldFromView(self.searchBar)?.enablesReturnKeyAutomatically = false
        self.getTextFieldFromView(self.searchBar)?.returnKeyType = UIReturnKeyType.Done
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.tableFooterView = UIView(frame: CGRectMake(0, 0, 0, 0))
        
        // ****************************************//
        // For Debug...
        if (!self._ap.hideBanner) {
            self.canDisplayBannerAds = true
        } else {
            self.canDisplayBannerAds = false
        }
        // ****************************************//
    }
    
    // セクションタイトル
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        // 日付ごとにセクションタイトルを設定
//        if let object = self.getSendHistoryData(self._searchWord) {
//            for result in object {
//                var df = NSDateFormatter()
//                df.dateFormat = "yyyy/MM/dd"
//                self._section.append(df.stringFromDate((result as SendHistory).send_d!))
//            }
//            let groupBySendD = NSOrderedSet(array: self._section)
//            return groupBySendD[section] as? String
//        } else {
//            return ""
//        }
        return "履歴一覧"
    }
//
    // セクション数
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//
//        // 日付ごとにセクションを設置
//        if let object = self.getSendHistoryData(self._searchWord) {
//            for result in object {
//                var df = NSDateFormatter()
//                df.dateFormat = "yyyy/MM/dd"
//                self._section.append(df.stringFromDate((result as SendHistory).send_d!))
//            }
//            let groupBySendD = NSOrderedSet(array: self._section)
//            return Int(groupBySendD.count)
//        } else {
//            return 1
//        }
        return 1
    }
    
    // セルの行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // 日付ごとにセクションを設置
//        var sectionContent = [NSArray]()
//        var df = NSDateFormatter()
//        df.dateFormat = "yyyy/MM/dd"
//        for result in self._section {
//            if let outs = getSendHistoryData(self._searchWord) {
//                var buf = [NSObject]()
//                for out in outs {
//                    if (result == df.stringFromDate((out as SendHistory).send_d!)) {
//                        buf.append(out)
//                    }
//                }
//                sectionContent.append(buf)
//            }
//        }
//        return sectionContent[section].count
        if let outs = getSendHistoryData(self._searchWord) {
            return Int(outs.count)
        } else {
            return 1
        }
    }
    
    // セルの行幅
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110.0 // 固定値
    }
    
    // テーブルセル 内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // データ取り出し
        if let sendHistory = getSendHistoryData(self._searchWord) {
            if let object = sendHistory[UInt(indexPath.row)] as? SendHistory {
                
                // セルを定義
                var cell = tableView.dequeueReusableCellWithIdentifier("sendHistoryCell") as TemplateHeadCell
                
                // テンプレート名
                var templateName = cell.viewWithTag(1) as UILabel
                templateName.text = "\(object.template_name)"
                templateName.textColor = UIColor.MainColor()
                
                // 送信先(TO)
                var addressTo = cell.viewWithTag(2) as UILabel
                addressTo.text = "宛先：\(object.mail_address_to)"
                
                // 送信先(CC)
                var addressCc = cell.viewWithTag(3) as UILabel
                addressCc.text = "Cc：\(object.mail_address_cc)"
                
                // 送信先(BCC)
                var addressBcc = cell.viewWithTag(4) as UILabel
                addressBcc.text = "Bcc：\(object.mail_address_bcc)"
                
                // 件名
                var mailTitle = cell.viewWithTag(5) as UILabel
                mailTitle.text = "\(object.mail_title)"
                
                // 送信日
                var sendD = cell.viewWithTag(7) as UILabel
                let df = NSDateFormatter()
                df.dateFormat = "yyyy/MM/dd HH:mm:ss"
                sendD.text = "\(df.stringFromDate(object.send_d!))"
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    // Cell 選択イベント
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // テンプレートHEAD データ取得
        if let sendHistory = self.getSendHistoryData(self._searchWord) {
            let object = sendHistory[UInt(indexPath.row)] as SendHistory
            
            // AppDelegateにデータを渡す
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            appDelegate.sendHistoryNo = object.history_no
            appDelegate.sendHistorySendD = object.send_d
            
            self.performSegueWithIdentifier("toSendHistoryData",sender: nil)
        }
        
        // 選択解除
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // テンプレートHEAD 削除処理
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // 編集モードにて削除が選択された場合
        if editingStyle == .Delete {
            
            // OKボタン作成
            let okAction = UIAlertAction(title: "OK", style: .Default) {
                action in
                
                // 履歴削除
                if let sendHistory = self.getSendHistoryData(self._searchWord) {
                    SendHistory.deleteSendHistory(sendHistory[UInt(indexPath.row)].history_no)
                }
                
                // テーブルデータ更新
                self.tableView.reloadData()
                
                return
            }
            ViewCommon.confirmDiarog(self, msg: "履歴を削除します。\nよろしいですか？", okAction: okAction, cancelAction: nil)
        }
    }
    
    // テーブル 編集モード
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        tableView?.setEditing(editing, animated: animated)
    }
    
    // テーブル 編集可否
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func indexOfArray(array:[AnyObject], searchObject: AnyObject)-> Int? {
        for (index, value) in enumerate(array) {
            if value as UIViewController == searchObject as UIViewController {
                return index
            }
        }
        return nil
    }
    
    // 検索ボタンクリックイベント
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.view.endEditing(true)
        self.tableView.reloadData()
    }
    
    // 検索バー値変更イベント
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self._searchWord = searchText
        self.tableView.reloadData()
    }
    
    // 検索バーからテキストフィールドオブジェクトを検索
    func getTextFieldFromView(view: UIView) -> UITextField? {
        for subView in view.subviews {
            if (subView.isKindOfClass(UITextField)) {
                return subView as? UITextField
            } else {
                if let textField: UITextField = self.getTextFieldFromView(subView as UIView) {
                    return textField
                }
            }
        }
        return nil
    }
    
    // 履歴情報取得
    func getSendHistoryData(str: String) -> RLMResults? {
        if (StringCommon.isBlank(str)) {
            return SendHistory.allObjects().sortedResultsUsingProperty("send_d", ascending: false)
        } else {
            return SendHistory.objectsWhere("template_name CONTAINS %@ OR mail_title CONTAINS %@ OR mail_body CONTAINS %@", str, str, str).sortedResultsUsingProperty("send_d", ascending: false)
        }
    }
    
    @IBAction func returnSendHistory(){
        self.tableView.reloadData()
    }
}
