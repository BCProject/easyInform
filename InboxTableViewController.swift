//
//  InboxTableViewController.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/13.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import UIKit
import Realm
import MessageUI

struct Cells {
    static let template: NSInteger = 0
    static let templateSection: NSInteger = 0
    static let itemSection: NSInteger = 1
    static let templateHeadHeight: CGFloat = 180.0
    static let templateItemHeight: CGFloat = 80.0
    static let section: NSArray = ["テンプレート","アイテム"]
}

class InboxTableViewController: UITableViewController,  MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var composeBt: UIBarButtonItem!
    
    var _ap:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        // テーブルデータ再取得
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.tableFooterView = UIView(frame: CGRectMake(0, 0, 0, 0))
        self.tableView.reloadData()
    }
    
    // セクションタイトル
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Cells.section[section] as? String
    }
    
    // セクション数
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        //テンプレートHEADに紐づくITEM(N個)
        if let key = self._ap.template {
            if (!StringCommon.isBlank(key)) {
                if let results = TemplateItem.selectAllTemplateItem("\(key)") {
                    return Cells.section.count
                } else {
                    return 1
                }
            }
        }
        return 1
    }
    
    // セルの行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // テンプレートHEAD(1個)
        if (section == 0) {
            return 1
        } else {
            
            //テンプレートHEADに紐づくITEM(N個) + アイテム追加
            if let key = self._ap.template {
                if (!StringCommon.isBlank(key)) {
                    if let results = TemplateItem.selectAllTemplateItem("\(key)") {
                        return Int(results.count) + 1
                    } else {
                        return 1
                    }
                }
            }
            return 1
        }
    }
    
    // セルの行幅
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return Cells.templateItemHeight
        
    }
    
    // テーブルセル 内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // テンプレートItem用変数
        var index: Int = 0
        
        //テンプレートHEADに紐づくITEM(N個) + アイテム追加
        if let key = self._ap.template {
            if (!StringCommon.isBlank(key)) {
                if let results = TemplateItem.selectAllTemplateItem("\(key)") {
                    index = Int(results.count)
                }
            }
        }
        
        // セルを定義
        if (indexPath.row == Cells.template && indexPath.section == Cells.templateSection) {

            // セルを定義
            var templateHeadHead: TemplateHeadCell = tableView.dequeueReusableCellWithIdentifier("templateHeadCell") as TemplateHeadCell
            
            templateHeadHead.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
            // テンプレートHEAD データ取得
            if let key = self._ap.template {
                let templateHead = TemplateHead.objectsWhere("template_name = '\(key)'")
                let object = templateHead.firstObject() as TemplateHead
                
                // アイコン
                var icon = templateHeadHead.viewWithTag(1) as UIImageView
                icon.image = UIImage(named:"template")
                
                // タイトル
                var title = templateHeadHead.viewWithTag(2) as UILabel
                title.text = "\(object.template_name)"
                title.textColor = UIColor.MainColor()
                
                // コンテンツ
                var content = templateHeadHead.viewWithTag(3) as UILabel
                content.text = "\(object.mail_title)"
                content.sizeToFit()
                content.numberOfLines = 0
            }
            
            return templateHeadHead
            
        } else if (indexPath.row < index && indexPath.section == Cells.itemSection) {
            
            // セルを定義
            var templateItemCell = tableView.dequeueReusableCellWithIdentifier("templateItemCell") as TemplateItemCell
            
            // 現在のセルに対するテンプレートITEMを取得
            var object = TemplateItem()
            if let key = self._ap.template {
                object = TemplateItem.selectTemplateItem(key, disp_no: (indexPath.row))
                
                // アイコン
                var icon = templateItemCell.viewWithTag(1) as UIImageView
                icon.image = UIImage(named:"\(object.item_image)")
                
                // タイトル
                var title = templateItemCell.viewWithTag(2) as UILabel
                title.text = "\(object.item_title)"
                title.textColor = UIColor.MainColor()
                
                // コンテンツ
                var content = templateItemCell.viewWithTag(3) as UILabel
                content.text = "\(object.item_content)"
                content.sizeToFit()
                content.numberOfLines = 0
            }
            
            return templateItemCell
        } else {
            var createItemCell = tableView.dequeueReusableCellWithIdentifier("createItemCell") as TemplateItemCell
            
            // アイコン
            var icon = createItemCell.viewWithTag(1) as UIImageView
            icon.image = UIImage(named:"add")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            icon.tintColor = UIColor.MainColor()
            
            return createItemCell
        }
    }
    
    // テーブル 編集可否設定
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        // テンプレートItem用変数
        var index: Int = 0
        
        //テンプレートHEADに紐づくITEM(N個) + アイテム追加
        if let key = self._ap.template {
            if (!StringCommon.isBlank(key)) {
                if let results = TemplateItem.selectAllTemplateItem("\(key)") {
                    index = Int(results.count)
                }
            }
        }
        if (indexPath.section != Cells.templateSection && indexPath.row < index) {
            return true
        }
        return false
    }
    
    // テンプレート 削除設定
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // 編集モードにて削除が選択された場合
        if editingStyle == .Delete {
            
            // OKボタン作成
            let okAction = UIAlertAction(title: "OK", style: .Default) {
                action in
                
                // 選択されたテンプレートITEMのデータを取得
                if let key = self._ap.template {
                    
                    // テンプレートITEM削除
                    let object = TemplateItem.deleteTemplateItem(key, disp_no: (indexPath.row))
                    
                    // 確認ダイアログ表示
                    //ViewCommon.confirmDiarog(self, msg: "テンプレートアイテムを削除しました。", okAction: nil)
                    self.tableView.reloadData()
                    return
                    
                } else {
                
                    // 確認ダイアログ表示
                    ViewCommon.confirmDiarog(self, msg: "テンプレートアイテムが取得できませんでした。",okAction: nil)
                }
                return
            }
            ViewCommon.confirmDiarog(self, msg: "テンプレートアイテムを削除します。\nよろしいですか？", okAction: okAction, cancelAction: nil)
        }
    }
    
    // Cell 選択イベント
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // テンプレートItem用変数
        var index: Int = 0
        
        //テンプレートHEADに紐づくITEM(N個) + アイテム追加
        if let key = self._ap.template {
            if (!StringCommon.isBlank(key)) {
                if let results = TemplateItem.selectAllTemplateItem("\(key)") {
                    index = Int(results.count)
                }
            }
        }
        
        // テンプレートが選択された場合
        if (indexPath.row == Cells.template && indexPath.section == Cells.templateSection){
            
            // AppDelegateにデータを渡す
            self._ap.editTemplateName = self._ap.template
            
            // テンプレート編集画面へ遷移
            self.performSegueWithIdentifier("toTemplateEditView",sender: nil)
            
        } else if (indexPath.row < index && indexPath.section == Cells.itemSection){
            
            if let key = self._ap.template {
                
                // 選択したセルに該当するテンプレートITEMのデータを取得
                if let object = TemplateItem.selectTemplateItem(key, disp_no: (indexPath.row)) {
                    
                    // 取得したテンプレートITEMのアイテム種類で処理分岐
                    switch (object.item_type) {
                    case ItemType.DATE_YYYYMMDD_SLA:
                        let df = NSDateFormatter()
                        df.locale     = NSLocale(localeIdentifier: "EN")
                        df.dateFormat = "yyyy/MM/dd"
                        inputDateDialog("\(object.item_title)", contents: "\(object.item_content)", index: (indexPath.row), df: df)
                        break
                    case ItemType.DATE_YYYYMMDD_JA:
                        let df = NSDateFormatter()
                        df.locale     = NSLocale(localeIdentifier: "JA")
                        df.dateFormat = "yyyy年MM月dd日"
                        inputDateDialog("\(object.item_title)", contents: "\(object.item_content)", index: (indexPath.row), df: df)
                        break
                    case ItemType.DATE_YYYYMMDD_HI:
                        let df = NSDateFormatter()
                        df.locale     = NSLocale(localeIdentifier: "EN")
                        df.dateFormat = "yyyy-MM-dd"
                        inputDateDialog("\(object.item_title)", contents: "\(object.item_content)", index: (indexPath.row), df: df)
                        break
                    case ItemType.DATE_YYYYMM_SLA:
                        let df = NSDateFormatter()
                        df.locale     = NSLocale(localeIdentifier: "EN")
                        df.dateFormat = "yyyy/MM"
                        inputDateDialog("\(object.item_title)", contents: "\(object.item_content)", index: (indexPath.row), df: df)
                        break
                    case ItemType.DATE_YYYYMM_JA:
                        let df = NSDateFormatter()
                        df.locale     = NSLocale(localeIdentifier: "JA")
                        df.dateFormat = "yyyy年MM月"
                        inputDateDialog("\(object.item_title)", contents: "\(object.item_content)", index: (indexPath.row), df: df)
                        break
                    case ItemType.DATE_YYYYMM_HI:
                        let df = NSDateFormatter()
                        df.locale     = NSLocale(localeIdentifier: "EN")
                        df.dateFormat = "yyyy-MM"
                        inputDateDialog("\(object.item_title)", contents: "\(object.item_content)", index: (indexPath.row), df: df)
                        break
                    case ItemType.DATE_MMDD_SLA:
                        let df = NSDateFormatter()
                        df.locale     = NSLocale(localeIdentifier: "EN")
                        df.dateFormat = "MM/dd"
                        inputDateDialog("\(object.item_title)", contents: "\(object.item_content)", index: (indexPath.row), df: df)
                        break
                    case ItemType.DATE_MMDD_JA:
                        let df = NSDateFormatter()
                        df.locale     = NSLocale(localeIdentifier: "JA")
                        df.dateFormat = "MM月dd日"
                        inputDateDialog("\(object.item_title)", contents: "\(object.item_content)", index: (indexPath.row), df: df)
                        break
                    case ItemType.DATE_MMDD_HI:
                        let df = NSDateFormatter()
                        df.locale     = NSLocale(localeIdentifier: "EN")
                        df.dateFormat = "MM-dd"
                        inputDateDialog("\(object.item_title)", contents: "\(object.item_content)", index: (indexPath.row), df: df)
                        break
                    case ItemType.DATE_MD_SLA:
                        let df = NSDateFormatter()
                        df.locale     = NSLocale(localeIdentifier: "EN")
                        df.dateFormat = "M/d"
                        inputDateDialog("\(object.item_title)", contents: "\(object.item_content)", index: (indexPath.row), df: df)
                        break
                    case ItemType.DATE_MD_JA:
                        let df = NSDateFormatter()
                        df.locale     = NSLocale(localeIdentifier: "JA")
                        df.dateFormat = "M月d日"
                        inputDateDialog("\(object.item_title)", contents: "\(object.item_content)", index: (indexPath.row), df: df)
                        break
                    case ItemType.DATE_MD_HI:
                        let df = NSDateFormatter()
                        df.locale     = NSLocale(localeIdentifier: "EN")
                        df.dateFormat = "M-d"
                        inputDateDialog("\(object.item_title)", contents: "\(object.item_content)", index: (indexPath.row), df: df)
                        break
                    case ItemType.DATETIME_MMDD_HHMM_COL:
                        let df = NSDateFormatter()
                        df.locale     = NSLocale(localeIdentifier: "EN")
                        df.dateFormat = "MM/dd HH:mm"
                        inputDateTimeDialog("\(object.item_title)", contents: "\(object.item_content)", index: (indexPath.row), df: df)
                        break
                    case ItemType.DATETIME_MMDD_HHMM_JA:
                        let df = NSDateFormatter()
                        df.locale     = NSLocale(localeIdentifier: "JA")
                        df.dateFormat = "MM月dd日 HH時mm分"
                        inputDateTimeDialog("\(object.item_title)", contents: "\(object.item_content)", index: (indexPath.row), df: df)
                        break
                    case ItemType.DATETIME_MD_HMM_COL:
                        let df = NSDateFormatter()
                        df.locale     = NSLocale(localeIdentifier: "EN")
                        df.dateFormat = "M/d H:mm"
                        inputDateTimeDialog("\(object.item_title)", contents: "\(object.item_content)", index: (indexPath.row), df: df)
                        break
                    case ItemType.DATETIME_MD_HMM_JA:
                        let df = NSDateFormatter()
                        df.locale     = NSLocale(localeIdentifier: "JA")
                        df.dateFormat = "M月d日 H時mm分"
                        inputDateTimeDialog("\(object.item_title)", contents: "\(object.item_content)", index: (indexPath.row), df: df)
                        break
                    case ItemType.TIME_HHMM_COL:
                        let df = NSDateFormatter()
                        df.locale     = NSLocale(localeIdentifier: "EN")
                        df.dateFormat = "HH:mm"
                        inputTimeDialog("\(object.item_title)", contents: "\(object.item_content)", index: (indexPath.row), df: df)
                        break
                    case ItemType.TIME_HHMM_JA:
                        let df = NSDateFormatter()
                        df.locale     = NSLocale(localeIdentifier: "JA")
                        df.dateFormat = "HH時mm分"
                        inputTimeDialog("\(object.item_title)", contents: "\(object.item_content)", index: (indexPath.row), df: df)
                        break
                    case ItemType.TIME_HMM_COL:
                        let df = NSDateFormatter()
                        df.locale     = NSLocale(localeIdentifier: "EN")
                        df.dateFormat = "H:mm"
                        inputTimeDialog("\(object.item_title)", contents: "\(object.item_content)", index: (indexPath.row), df: df)
                        break
                    case ItemType.TIME_HMM_JA:
                        let df = NSDateFormatter()
                        df.locale     = NSLocale(localeIdentifier: "JA")
                        df.dateFormat = "H時mm分"
                        inputTimeDialog("\(object.item_title)", contents: "\(object.item_content)", index: (indexPath.row), df: df)
                        break
                    case ItemType.DAY:
                        inputDayDialog("\(object.item_title)", contents: "\(object.item_content)", index: (indexPath.row))
                        break
                    case ItemType.TEXTFIELD:
                        inputTextDialog("\(object.item_title)", contents: "\(object.item_content)", index: (indexPath.row))
                        break
                    default:
                        inputTextDialog("\(object.item_title)", contents: "\(object.item_content)", index: (indexPath.row))
                        break
                    }
                }
            }
        } else {
            createItemDialog()
        }
        
        // セル選択解除
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // メール作成ボタン クリックイベント
    @IBAction func onClickComposeButton() {
        
        if (!MFMailComposeViewController.canSendMail()) {
            
            // 確認ダイアログ表示
            ViewCommon.confirmDiarog(self, msg: "メーラーを取得できませんでした。",okAction: nil)
            return
        }
        
        // Appデリゲートからテンプレート名を取得
        if let key = self._ap.template {
            
            // テンプレートHEAD データ取得
            if let object = TemplateHead.selectTemplateHead(key) {
                
                // メールコントローラー定義
                let mailController = MFMailComposeViewController()
                
                // メーラーに情報を転送するためのオブジェクト
                mailController.mailComposeDelegate = self
                mailController.setToRecipients(StringCommon.stringToArray(object.mail_address_to))
                mailController.setCcRecipients(StringCommon.stringToArray(object.mail_address_cc))
                mailController.setBccRecipients(StringCommon.stringToArray(object.mail_address_bcc))
                mailController.setSubject(MaillerCommon.createSentence(key, str: object.mail_title))
                mailController.setMessageBody(MaillerCommon.createSentence(key, str: object.mail_body), isHTML: false)
                
                // メール送信画面へ遷移
                self.presentViewController(mailController, animated: true, completion: nil)
            }
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
            
            // Appデリゲートからテンプレート名を取得
            if let key = self._ap.template {
                
                // テンプレートHEAD データ取得
                if let object = TemplateHead.selectTemplateHead(key) {
                
                    // 履歴情報を作成
                    let sendHistory = SendHistory()
                    let now:NSDate = NSDate()
                    sendHistory.template_name = object.template_name
                    sendHistory.mail_address_to = object.mail_address_to
                    sendHistory.mail_address_cc = object.mail_address_cc
                    sendHistory.mail_address_bcc = object.mail_address_bcc
                    sendHistory.mail_address = object.mail_address
                    sendHistory.mail_title = MaillerCommon.createSentence(key, str: object.mail_title)
                    sendHistory.mail_body = MaillerCommon.createSentence(key, str: object.mail_body)
                    sendHistory.send_d = now
                    SendHistory.insertSendHistory(sendHistory)
                }
            }
            break
        case MFMailComposeResultFailed.value:
            println("Email Send Failed")
            break
        default:
            break
        }
        
        // Inbox画面に戻る
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Addボタン クリックイベント
    func onClickAddButton() {
        createItemDialog()
    }
    
    // テンプレートITEM 作成ダイアログ
    func createItemDialog() {
        
        // アラートコントローラー作成
        let alertController: InputTwoTextAlertController = InputTwoTextAlertController(title: "アイテム作成", message: "テンプレートアイテムを\n設定してください", preferredStyle: .Alert)
        alertController.setTextFieldOption("アイテム名", placeholder2: "初期値", text1: "", text2: "")
        
        // キャンセルボタン作成
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .Cancel) { action -> Void in
            return
        }
        alertController.addAction(cancelAction)
        
        // 作成ボタン
        let setAction: UIAlertAction = UIAlertAction(title: "作成", style: .Default) { action -> Void in
            
            // テンプレートHEAD キー取得
            if let key = self._ap.template {
                
                // 作成用にテンプレートHEAD・ITEMオブジェクトを定義し値をセット
                let templateItem: TemplateItem = TemplateItem()
                
                templateItem.item_title = alertController._textField1.text
                templateItem.item_content = alertController._textField2.text
                templateItem.item_type = ItemType.TEXTFIELD
                templateItem.item_image = "note"
                if let disp_no = TemplateItem.getLastDispNo(key) {
                    templateItem.disp_no = disp_no
                }
                
                // テンプレートITEM 作成
                TemplateItem.insertTemplateItem(key, object: templateItem)
                
                // テーブルデータ更新
                self.tableView.reloadData()
            }
        }
        alertController.addAction(setAction)
        
        // アラート表示
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // テンプレートITEM (Text)編集ダイアログ
    func inputTextDialog(title:String, contents:String, index: NSInteger) {
        
        // アラートコントローラー作成
        let alertController: InputOneTextAlertController = InputOneTextAlertController(title: title, message: "\(title)を設定してください", preferredStyle: .Alert)
        alertController.setTextFieldOption("内容", text1: contents)
        
        // キャンセルボタン作成
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .Cancel) { action -> Void in
            return
        }
        alertController.addAction(cancelAction)
        
        // 設定ボタン作成
        let setAction: UIAlertAction = UIAlertAction(title: "設定", style: .Default) { action -> Void in
            
            // テンプレートHEAD キー取得
            if let key = self._ap.template {
                
                // 作成用にテンプレートITEMオブジェクトを定義し値をセット
                let templateItem: TemplateItem = TemplateItem()
                
                // 入力フォームから値を取得
                templateItem.item_content = alertController._textField1.text
                
                // テンプレートITEM 更新
                TemplateItem.updateTemplateItem(templateItem, key: key, disp_no: index)
                
                // データ更新
                self.tableView.reloadData()
            }
        }
        alertController.addAction(setAction)
        
        // アラート表示
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // テンプレートITEM (Date)編集ダイアログ
    func inputDateDialog(title:String, contents:String, index: NSInteger, df: NSDateFormatter) {
        
        // アラートコントローラー作成
        let alertController: InputOneDateAlertController = InputOneDateAlertController(title: title, message: "\(title)を設定してください", preferredStyle: .Alert)
        alertController.setTextFieldOption("内容", text1: contents, df: df)
        
        // キャンセルボタン作成
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .Cancel) { action -> Void in
            return
        }
        alertController.addAction(cancelAction)
        
        // 設定ボタン作成
        let setAction: UIAlertAction = UIAlertAction(title: "設定", style: .Default) { action -> Void in
            
            // テンプレートHEAD キー取得
            if let key = self._ap.template {
                
                // 作成用にテンプレートITEMオブジェクトを定義し値をセット
                let templateItem: TemplateItem = TemplateItem()
                
                // 入力フォームから値を取得
                templateItem.item_content = alertController._textField1.text
                
                // テンプレートITEM 更新
                TemplateItem.updateTemplateItem(templateItem, key: key, disp_no: index)
                
                // データ更新
                self.tableView.reloadData()
            }
        }
        alertController.addAction(setAction)
        
        // アラート表示
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // テンプレートITEM (DateTime)編集ダイアログ
    func inputDateTimeDialog(title:String, contents:String, index: NSInteger, df: NSDateFormatter) {
        
        // アラートコントローラー作成
        let alertController: InputOneDateTimeAlertController = InputOneDateTimeAlertController(title: title, message: "\(title)を設定してください", preferredStyle: .Alert)
        alertController.setTextFieldOption("内容", text1: contents, df: df)
        
        // キャンセルボタン作成
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .Cancel) { action -> Void in
            return
        }
        alertController.addAction(cancelAction)
        
        // 設定ボタン作成
        let setAction: UIAlertAction = UIAlertAction(title: "設定", style: .Default) { action -> Void in
            
            // テンプレートHEAD キー取得
            if let key = self._ap.template {
                
                // 作成用にテンプレートITEMオブジェクトを定義し値をセット
                let templateItem: TemplateItem = TemplateItem()
                
                // 入力フォームから値を取得
                templateItem.item_content = alertController._textField1.text
                
                // テンプレートITEM 更新
                TemplateItem.updateTemplateItem(templateItem, key: key, disp_no: index)
                
                // データ更新
                self.tableView.reloadData()
            }
        }
        alertController.addAction(setAction)
        
        // アラート表示
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // テンプレートITEM (Time)編集ダイアログ
    func inputTimeDialog(title:String, contents:String, index: NSInteger, df: NSDateFormatter) {
        
        // アラートコントローラー作成
        let alertController: InputOneTimeAlertController = InputOneTimeAlertController(title: title, message: "\(title)を設定してください", preferredStyle: .Alert)
        alertController.setTextFieldOption("内容", text1: contents, df: df)
        
        // キャンセルボタン作成
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .Cancel) { action -> Void in
            return
        }
        alertController.addAction(cancelAction)
        
        // 設定ボタン作成
        let setAction: UIAlertAction = UIAlertAction(title: "設定", style: .Default) { action -> Void in
            
            // テンプレートHEAD キー取得
            if let key = self._ap.template {
                
                // 作成用にテンプレートITEMオブジェクトを定義し値をセット
                let templateItem: TemplateItem = TemplateItem()
                
                // 入力フォームから値を取得
                templateItem.item_content = alertController._textField1.text
                
                // テンプレートITEM 更新
                TemplateItem.updateTemplateItem(templateItem, key: key, disp_no: index)
                
                // データ更新
                self.tableView.reloadData()
            }
        }
        alertController.addAction(setAction)
        
        // アラート表示
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // テンプレートITEM (Day)編集ダイアログ
    func inputDayDialog(title:String, contents:String, index: NSInteger) {
        
        // アラートコントローラー作成
        let alertController: InputOneDayAlertController = InputOneDayAlertController(title: title, message: "\(title)を設定してください", preferredStyle: .Alert)
        alertController.setTextFieldOption("内容", text1: contents)
        
        // キャンセルボタン作成
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .Cancel) { action -> Void in
            return
        }
        alertController.addAction(cancelAction)
        
        // 設定ボタン作成
        let setAction: UIAlertAction = UIAlertAction(title: "設定", style: .Default) { action -> Void in
            
            // テンプレートHEAD キー取得
            if let key = self._ap.template {
                
                // 作成用にテンプレートITEMオブジェクトを定義し値をセット
                let templateItem: TemplateItem = TemplateItem()
                
                // 入力フォームから値を取得
                templateItem.item_content = alertController._textField1.text
                
                // テンプレートITEM 更新
                TemplateItem.updateTemplateItem(templateItem, key: key, disp_no: index)
                
                // データ更新
                self.tableView.reloadData()
            }
        }
        alertController.addAction(setAction)
        
        // アラート表示
        presentViewController(alertController, animated: true, completion: nil)
    }
}
