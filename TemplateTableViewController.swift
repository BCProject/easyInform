//
//  TemplateTableViewController.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/13.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import UIKit
import Realm
import iAd

class TemplateTableViewController: UITableViewController,  ADBannerViewDelegate {
    
    @IBOutlet weak var historyBt: UIBarButtonItem!
    
    // 広告バナー定義
    let _iadBanner = ADBannerView(adType: ADAdType.Banner)
    
    // Appデリゲート
    var _ap:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 長押し用ジェスチャー
        let longPressRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "rowButtonAction:")
        longPressRecognizer.allowableMovement = 15
        longPressRecognizer.minimumPressDuration = 0.4
        self.tableView.addGestureRecognizer(longPressRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.tableFooterView = UIView(frame: CGRectMake(0, 0, 0, 0))
        self.tableView.reloadData()
        
        if let object = SendHistory.allObjects() {
            if (object.count > 0) {
                historyBt.enabled = true
            } else {
                historyBt.enabled = false
            }
        }
        
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
        return "テンプレート一覧"
    }
    
    // セクション数
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // セルの行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let object = getTemplateHeadData() {
            return Int(object.count) + 1
        } else {
            return 1
        }
    }
    
    // セルの行幅
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var index: Int = 0
        if let object = getTemplateHeadData() {
            index = Int(object.count)
        }
        if (indexPath.row < index) {
            return Cells.templateHeight
        } else {
            return Cells.templateItemHeight
        }
    }
    
    // テーブルセル 内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var index: Int = 0
        if let object = getTemplateHeadData() {
            index = Int(object.count)
        }
        
        // データ取り出し
        if (indexPath.row < index) {
            if let templateHead = getTemplateHeadData() {
                if let object = templateHead[UInt(indexPath.row)] as? TemplateHead {
                    
                    // セルを定義
                    var cell = tableView.dequeueReusableCellWithIdentifier("templateCell") as TemplateHeadCell
                    
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
                    
                    // 本文
                    var mailBody = cell.viewWithTag(6) as UILabel
                    mailBody.text = "\(object.mail_body)"
                    
                    return cell
                }
            }
        } else {
            var createItemCell = tableView.dequeueReusableCellWithIdentifier("createItemCell") as TemplateItemCell
            return createItemCell
        }
        return TemplateItemCell()
    }
    
    // Cell 選択イベント
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var index: Int = 0
        if let object = getTemplateHeadData() {
            index = Int(object.count)
        }
        
        // データ取り出し
        if (indexPath.row < index) {
        
            // テンプレートHEAD データ取得
            if let templateHead = self.getTemplateHeadData() {
                let object = templateHead[UInt(indexPath.row)] as TemplateHead
                
                // AppDelegateにデータを渡す
                var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                appDelegate.template = object.template_name
            }
            
            // テンプレート作成画面へ遷移
            self.performSegueWithIdentifier("toInboxView",sender: nil)
            
        } else {
            addDialog()
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
                
                // テンプレートHEAD 削除
                if let templateHead = self.getTemplateHeadData() {
                    TemplateHead.deleteTemplateHead(templateHead[UInt(indexPath.row)].template_name)
                }
                
                // テーブルデータ更新
                self.tableView.reloadData()
                
                return
            }
            ViewCommon.confirmDiarog(self, msg: "テンプレートを削除します。\nよろしいですか？", okAction: okAction, cancelAction: nil)
        }
    }
    
    // テーブル 編集モード
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        tableView?.setEditing(editing, animated: animated)
    }
    
    // テーブル 編集可否
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        var index: Int = 0
        if let object = getTemplateHeadData() {
            index = Int(object.count)
        }
        if (indexPath.row < index) {
            return true
        }
        return false
    }
    
    // 新規作成ダイアログ
    func addDialog() {
        
        // アラートコントローラ作成
        let alertController: InputOneTextAlertController = InputOneTextAlertController(title: "新規作成", message: "テンプレート名を設定してください", preferredStyle: .Alert)
        alertController.setTextFieldOption("テンプレート名", text1: "")
        
        // キャンセルボタン作成
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .Cancel) { action -> Void in
            return
        }
        alertController.addAction(cancelAction)
        
        // 作成ボタン
        let setAction: UIAlertAction = UIAlertAction(title: "作成", style: .Default) { action -> Void in
            
            // 入力フォームの内容でテンプレートHEADデータを取得
            if let text = alertController._textField1.text {
                var object = TemplateHead.objectsWithPredicate(NSPredicate(format: "template_name = %@", text))
                
                // 取得できない場合は新規作成
                if (object.count == 0) {
                    
                    // データ作成用にテンプレートHEADオブジェクト作成し値をセット
                    let templateHead:TemplateHead = TemplateHead()
                    
                    templateHead.template_name = text
                    if let no = TemplateHead.getLastDispNo() {
                        templateHead.disp_no = no
                    }
                    TemplateHead.insertTemplateHead(templateHead)
                    self.tableView.reloadData()
                    
                } else {
                    
                    // 取得できた場合は確認ダイアログを表示する
                    ViewCommon.confirmDiarog(self,msg: "「\(text)」は既に登録されております。",okAction: nil)
                }
            }
            return
        }
        setAction.enabled = false
        alertController.addAction(setAction)
        
        alertController._notification.addObserver(self, selector: "changeTemplateName:", name: UITextFieldTextDidChangeNotification, object: nil)
        
        // アラート表示
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // テンプレート名変更イベント
    func changeTemplateName(sender: NSNotification){
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
    
    // テンプレートHEAD情報取得
    func getTemplateHeadData() -> RLMResults? {
        return TemplateHead.allObjects().sortedResultsUsingProperty("disp_no", ascending: true)
    }
    
    // 長押し判別用
    @IBAction func rowButtonAction(gestureRecognizer: UILongPressGestureRecognizer){

        // 座標オブジェクト(タップした座標を格納)
        let p: CGPoint = gestureRecognizer.locationInView(tableView)

        // タップした位置のセルIndexを取得する
        if let indexPath = tableView.indexPathForRowAtPoint(p) {
            if (gestureRecognizer.state == UIGestureRecognizerState.Began) {

                // タップしたセルのテンプレートHEADデータを取得
                if let templateHead = self.getTemplateHeadData() {
                    let object = templateHead[UInt(indexPath.row)] as TemplateHead
                    // AppDelegateにデータを渡す
                    self._ap.editTemplateName = object.template_name
                }

                // テンプレート編集画面へ遷移
                self.performSegueWithIdentifier("toTemplateEditView",sender: nil)
            }
        }
    }
    
    @IBAction func returnTemplateView(segue: UIStoryboardSegue) {
        self.tableView.reloadData()
    }
    
    // 履歴ボタン押下イベント
    @IBAction func onClickHistory() {
        
        // 履歴一覧画面へ遷移
        self.performSegueWithIdentifier("toSendHistoryView",sender: nil)
    }
    
    // 設定ボタン押下イベント
    @IBAction func onClickSetting() {
        
        // 設定画面へ遷移
        self.performSegueWithIdentifier("toSettingView",sender: nil)
    }
    
}
