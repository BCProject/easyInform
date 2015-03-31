//
//  SendHistoryDataTableViewController.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/14.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import UIKit
import Realm

class SendHistoryDataTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var cancelBt: UIBarButtonItem!
    @IBOutlet weak var textView: MailBodyTextView!
    
    // 画面描画 計算用変数
    var _drawHeight: CGFloat?
    var _drawWidth:CGFloat?
    var _keyBoardSize:CGRect?
    var _textCurrentSize: CGRect?
    
    // テンプレート作成画面 テキストフィールドオブジェクト
    var _addressTo = UITextField()
    var _addressToDidLoad = false
    var _addressCc = UITextField()
    var _addressCcDidLoad = false
    var _addressBcc = UITextField()
    var _addressBccDidLoad = false
    var _subject = UITextField()
    var _subjectDidLoad = false
    var _textDidLoad = false
    var _editTextViewFlag = false

    
    // Appデリゲートオブジェクト
    let _ap:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 描画エリアを計算
        calculateHeights()

        // 本文(TextView)リサイズ
        self.textView.resize((self._drawHeight! - TemplateCell.withoutBodyHeight), width: (self._drawWidth! - 10.0))
    }
    
    // 描画領域計算
    func calculateHeights() {
        self._ap.statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        self._ap.statusBarWidth = UIApplication.sharedApplication().statusBarFrame.width
        self._ap.navBarHeight = self.navigationController!.navigationBar.frame.size.height
        self._ap.availableViewHeight = self.view.frame.size.height - self._ap.statusBarHeight! - self._ap.navBarHeight!
        self._ap.availableViewWidth = self.view.frame.size.width
        
        // ナビゲーションバーを除いた描画領域を格納
        if (self._drawHeight == nil) {
            self._drawHeight = self._ap.availableViewHeight
        }
        if (self._drawWidth == nil) {
            self._drawWidth = self._ap.statusBarWidth
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // テーブルセル行幅
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.row) {
        case 0:
            return TemplateCell.addressToHeight
        case 1:
            return TemplateCell.addressCcHeight
        case 2:
            return TemplateCell.addressBccHeight
        case 3:
            return TemplateCell.subjectHeight
        default:
            return 0.0
        }
    }
    
    // テーブルセル行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TemplateCell.rowCount
    }
    
    // テーブルセル 内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // テンプレートHEAD情報取得
        if let object = SendHistory(forPrimaryKey: self._ap.sendHistoryNo) {
            switch (indexPath.row) {
            case 0:
                // セルを定義
                var cell = tableView.dequeueReusableCellWithIdentifier("addressToCell") as TemplateEditTableViewCell
                var addressTo = cell.viewWithTag(2) as UITextField
                if (!self._addressToDidLoad) {
                    addressTo.text = object.mail_address_to
                }
                
                return cell
            case 1:
                // セルを定義
                var cell = tableView.dequeueReusableCellWithIdentifier("addressCcCell") as TemplateEditTableViewCell
                var addressCc = cell.viewWithTag(2) as UITextField
                if (!self._addressCcDidLoad) {
                    addressCc.text = object.mail_address_cc
                }
                
                return cell
            case 2:
                // セルを定義
                var cell = tableView.dequeueReusableCellWithIdentifier("addressBccCell") as TemplateEditTableViewCell
                var addressBcc = cell.viewWithTag(2) as UITextField
                if (!self._addressBccDidLoad) {
                    addressBcc.text = object.mail_address_bcc
                }
                
                return cell
            case 3:
                // セルを定義
                var cell = tableView.dequeueReusableCellWithIdentifier("subjectCell") as TemplateEditTableViewCell
                var subject = cell.viewWithTag(2) as UITextField
                if (!self._subjectDidLoad) {
                    subject.text = object.mail_title
                }
                
                return cell
            case 4:
                // セルを定義
                var cell = TemplateEditTableViewCell()
                if (!self._textDidLoad) {
                    self.textView.text = object.mail_body
                }
                
                return cell
                
            default:
                // 空のセルを定義
                var cell = UITableViewCell()
                return cell
            }
        }
        
        // 空のセルを定義
        var cell = UITableViewCell()
        return cell
    }
    
    // Cancelボタン クリックイベント
    @IBAction func onClickCancelButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        self._ap.editTemplateName = ""
        return
    }
}
