//
//  TemplateTableViewController.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/13.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import UIKit
import Realm

class TemplateTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    // NotificationToken定義
    private var _notificationToken : RLMNotificationToken?
    
    var _searchWord :String = ""
    var _ap:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TemplateHead NotificationToken
        self._notificationToken = RLMRealm.defaultRealm().addNotificationBlock{ note, realm in
            self.tableView.reloadData()
        }
        
//        // 長押し用ジェスチャー
//        let longPressRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "rowButtonAction:")
//        longPressRecognizer.allowableMovement = 15
//        longPressRecognizer.minimumPressDuration = 0.4
//        self.tableView.addGestureRecognizer(longPressRecognizer)
        
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
    }
    
    // セルの行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let object = getTemplateHeadData(self._searchWord) {
            return Int(object.count) + 1
        } else {
            return 1
        }
    }
    
    // セルの行幅
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var index: Int = 0
        if let object = getTemplateHeadData(self._searchWord) {
            index = Int(object.count)
        }
        if (indexPath.row < index) {
            return Cells.templateHeadHeight
        } else {
            return Cells.templateItemHeight
        }
    }
    
    // テーブルセル 内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var index: Int = 0
        if let object = getTemplateHeadData(self._searchWord) {
            index = Int(object.count)
        }
        
        // データ取り出し
        if (indexPath.row < index) {
            if let templateHead = getTemplateHeadData(self._searchWord) {
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
            
            // アイコン
            var icon = createItemCell.viewWithTag(1) as UIImageView
            icon.image = UIImage(named:"add")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            icon.tintColor = UIColor.MainColor()
            
            return createItemCell
        }
        return TemplateItemCell()
    }
    
    // Cell 選択イベント
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var index: Int = 0
        if let object = getTemplateHeadData(self._searchWord) {
            index = Int(object.count)
        }
        
        // データ取り出し
        if (indexPath.row < index) {
        
            // テンプレートHEAD データ取得
            if let templateHead = self.getTemplateHeadData(self._searchWord) {
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
                if let templateHead = self.getTemplateHeadData(self._searchWord) {
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
        if let object = getTemplateHeadData(self._searchWord) {
            index = Int(object.count)
        }
        if (indexPath.row < index) {
            return true
        }
        return false
    }
    
    // 長押し判別用
//    @IBAction func rowButtonAction(gestureRecognizer: UILongPressGestureRecognizer){
//        
//        // 座標オブジェクト(タップした座標を格納)
//        let p: CGPoint = gestureRecognizer.locationInView(tableView)
//        
//        // タップした位置のセルIndexを取得する
//        if let indexPath = tableView.indexPathForRowAtPoint(p) {
//            if (gestureRecognizer.state == UIGestureRecognizerState.Began) {
//                
//                // タップしたセルのテンプレートHEADデータを取得
//                if let templateHead = self.getTemplateHeadData(self._searchWord) {
//                    let object = templateHead[UInt(indexPath.row)] as TemplateHead
//                    // AppDelegateにデータを渡す
//                    self._ap.editTemplateName = object.template_name
//                }
//                
//                // テンプレート編集画面へ遷移
//                self.performSegueWithIdentifier("toTemplateEditView",sender: nil)
//            }
//        }
//    }
    
    // 新規作成ダイアログ
    func addDialog() {
        
        // テンプレート名入力フォーム
        var inputTemplateField: UITextField?
        
        // アラートコントローラ作成
        let alertController: UIAlertController = UIAlertController(title: "新規作成", message: "テンプレート名を設定してください", preferredStyle: .Alert)
        
        // キャンセルボタン作成
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .Cancel) { action -> Void in
            return
        }
        alertController.addAction(cancelAction)
        
        // 作成ボタン
        let setAction: UIAlertAction = UIAlertAction(title: "作成", style: .Default) { action -> Void in
            
            // 入力フォームの内容でテンプレートHEADデータを取得
            if let text = inputTemplateField?.text {
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
        alertController.addAction(setAction)
        
        // テンプレート名入力フォームをアラートコントローラに追加
        alertController.addTextFieldWithConfigurationHandler { textField -> Void in
            inputTemplateField = textField
            textField.placeholder = "テンプレート名"
        }
        
        // アラート表示
        presentViewController(alertController, animated: true, completion: nil)
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
    
    // テンプレートHEAD情報取得
    func getTemplateHeadData(str: String) -> RLMResults? {
        if (StringCommon.isBlank(str)) {
            return TemplateHead.allObjects().sortedResultsUsingProperty("disp_no", ascending: true)
        } else {
            return TemplateHead.objectsWhere("template_name CONTAINS %@ OR mail_title CONTAINS %@ OR mail_body CONTAINS %@", str, str, str).sortedResultsUsingProperty("disp_no", ascending: true)
        }
    }
    
    
    // データリフレッシュ
    @IBAction func returnTemplate(segue: UIStoryboardSegue) {
        self.tableView.reloadData()
    }
    
    
}
