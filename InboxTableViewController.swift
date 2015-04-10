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
import iAd

struct Cells {
    static let template: NSInteger = 0
    static let templateSection: NSInteger = 0
    static let itemSection: NSInteger = 1
    static let templateHeight: CGFloat = 190.0
    static let templateHeadHeight: CGFloat = 80.0
    static let templateItemHeight: CGFloat = 60.0
    static let section: NSArray = ["テンプレート","アイテム"]
}

class InboxTableViewController: UITableViewController,  MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var composeBt: UIBarButtonItem!
    
    // NotificationToken定義
    private var _notificationToken : RLMNotificationToken?
    
    var _ap:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self._notificationToken = RLMRealm.defaultRealm().addNotificationBlock{ note, realm in
            self.tableView.reloadData()
        }
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
        
        // テンプレートHEAD(1個)
        if (indexPath.section == 0) {
            return Cells.templateHeadHeight
        } else {
            return Cells.templateItemHeight
        }
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
                icon.image = UIImage(named:"\(ItemImage.IMAGE[object.item_image])")
                
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
        
        //編集モードにて削除が選択された場合
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
            
            // 現在のセルに対するテンプレートITEMを取得
            var object = TemplateItem()
            if let key = self._ap.template {
                object = TemplateItem.selectTemplateItem(key, disp_no: (indexPath.row))
                self._ap.editItemNo = object.item_no
                self._ap.editItemTitle = object.item_title
                
                // テンプレートItem編集画面へ遷移
                self.performSegueWithIdentifier("toTemplateItemEditView",sender: nil)
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
        let alertController: InputOneTextAlertController = InputOneTextAlertController(title: "新規作成", message: "アイテム名を設定してください", preferredStyle: .Alert)
        alertController.setTextFieldOption("アイテム名", text1: "")
        
        // キャンセルボタン作成
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .Cancel) { action -> Void in
            return
        }
        alertController.addAction(cancelAction)
        
        // 作成ボタン
        let setAction: UIAlertAction = UIAlertAction(title: "作成", style: .Default) { action -> Void in
            
            // テンプレートHEAD キー取得
            if let key = self._ap.template {
                
                if (!TemplateItem.existTemplateItem(key, itemTitle: alertController._textField1.text)) {
                
                    // 作成用にテンプレートHEAD・ITEMオブジェクトを定義し値をセット
                    let templateItem: TemplateItem = TemplateItem()
                    
                    templateItem.item_title = alertController._textField1.text
                    templateItem.item_type = ItemType.TEXT
                    templateItem.item_format = ItemFormat.NONE
                    templateItem.item_image = ItemImage.TEXT
                    if let disp_no = TemplateItem.getLastDispNo(key) {
                        templateItem.disp_no = disp_no
                    }
                    
                    // テンプレートITEM 作成
                    TemplateItem.insertTemplateItem(key, object: templateItem)
                    
                    // テーブルデータ更新
                    self.tableView.reloadData()

                } else {
                    // 取得できた場合は確認ダイアログを表示する
                    ViewCommon.confirmDiarog(self,msg: "「\(alertController._textField1.text)」は既に登録されております。",okAction: nil)
                }
            }
        }
        setAction.enabled = false
        alertController.addAction(setAction)
        
        alertController._notification.addObserver(self, selector: "changeItemName:", name: UITextFieldTextDidChangeNotification, object: nil)
        
        // アラート表示
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // アイテム名変更イベント
    func changeItemName(sender: NSNotification){
        let textField = sender.object as UITextField
        
        if let alertController = self.presentedViewController as? UIAlertController {
            var setAction = alertController.actions.last as UIAlertAction
            if (countElements(textField.text) > 0 && countElements(textField.text) < 30) {
                setAction.enabled = true
            } else {
                setAction.enabled = false
            }
        }
    }
}
