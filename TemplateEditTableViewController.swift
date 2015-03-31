//
//  TemplateEditTableViewController.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/14.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import UIKit
import Realm
import AddressBook
import AddressBookUI

struct TemplateCell {
    static let addressToHeight: CGFloat = 40.0
    static let addressCcHeight: CGFloat = 40.0
    static let addressBccHeight: CGFloat = 40.0
    static let subjectHeight: CGFloat = 40.0
    static let withoutBodyHeight: CGFloat = 160.0
    static let rowCount: NSInteger = 5
}

class TemplateEditTableViewController: UITableViewController, UITextFieldDelegate, ABPeoplePickerNavigationControllerDelegate {
    
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
    var _textChangeFlag = false
    
    // Appデリゲートオブジェクト
    let _ap:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 描画エリアを計算
        calculateHeights()
        
        // キーボード表示する際に送られるNSNotificationを受け取るための処理を追加
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShow:", name: UIKeyboardDidShowNotification, object: nil)
        
        // キーボード閉じる際に送られるNSNotificationを受け取るための処理を追加
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHide:", name: UIKeyboardDidHideNotification, object: nil)
        
        // TextViewを編集開始する際に送られるNSNotificationを受け取るための処理を追加
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "beginEditText:", name: UITextViewTextDidBeginEditingNotification, object: nil)
        
        // TextViewを編集終了する際に送られるNSNotificationを受け取るための処理を追加
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "endEditText:", name: UITextViewTextDidEndEditingNotification, object: nil)
        
        // TextViewの値が変更される際に送られるNSNotificationを受け取るための処理を追加
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeText:", name: UITextViewTextDidChangeNotification, object: nil)
        
        // キーボード上部にカスタムビューを表示
        let window = ItemSelectWindow()
        let keyBoard = KeyBoardViewOnTextView(frame: CGRectMake(0, 0, 320, 40))
        keyBoard._textView = self.textView
        keyBoard.drawKeyBoardView(self, window: window)
        self.textView.inputAccessoryView = keyBoard

        // 本文(TextView)リサイズ
        self.textView.resize((self._drawHeight! - TemplateCell.withoutBodyHeight), width: (self._drawWidth! - 10.0))
        
        self.textView.layoutManager.allowsNonContiguousLayout = false
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
        if let key = self._ap.editTemplateName {
            
            // テンプレートHEAD情報取得
            if let object = TemplateHead.objectsWithPredicate(NSPredicate(format: "template_name = %@", key)).firstObject() as? TemplateHead {
                switch (indexPath.row) {
                case 0:
                    // セルを定義
                    var cell = tableView.dequeueReusableCellWithIdentifier("addressToCell") as TemplateEditTableViewCell
                    var addressTo = cell.viewWithTag(2) as UITextField
                    if (!self._addressToDidLoad) {
                        addressTo.text = object.mail_address_to
                        addressTo.delegate = self
                        
                        var addToBt: AnyObject = UIButton.buttonWithType(UIButtonType.ContactAdd)
                        addToBt.addTarget(self, action: "onClickAddToBt", forControlEvents: UIControlEvents.TouchUpInside)
                        addressTo.rightView = addToBt as? UIView
                        addressTo.rightViewMode = UITextFieldViewMode.WhileEditing
                        self._addressTo = addressTo
                        
                        self._addressToDidLoad = true
                    }
                    
                    return cell
                case 1:
                    // セルを定義
                    var cell = tableView.dequeueReusableCellWithIdentifier("addressCcCell") as TemplateEditTableViewCell
                    var addressCc = cell.viewWithTag(2) as UITextField
                    if (!self._addressCcDidLoad) {
                        addressCc.text = object.mail_address_cc
                        addressCc.delegate = self
                        
                        var addCcBt: AnyObject = UIButton.buttonWithType(UIButtonType.ContactAdd)
                        addCcBt.addTarget(self, action: "onClickAddCcBt", forControlEvents: UIControlEvents.TouchUpInside)
                        addressCc.rightView = addCcBt as? UIView
                        addressCc.rightViewMode = UITextFieldViewMode.WhileEditing
                        self._addressCc = addressCc
                        
                        self._addressCcDidLoad = true
                    }
                    
                    return cell
                case 2:
                    // セルを定義
                    var cell = tableView.dequeueReusableCellWithIdentifier("addressBccCell") as TemplateEditTableViewCell
                    var addressBcc = cell.viewWithTag(2) as UITextField
                    if (!self._addressBccDidLoad) {
                        addressBcc.text = object.mail_address_bcc
                        addressBcc.delegate = self
                        
                        var addBccBt: AnyObject = UIButton.buttonWithType(UIButtonType.ContactAdd)
                        addBccBt.addTarget(self, action: "onClickAddBccBt", forControlEvents: UIControlEvents.TouchUpInside)
                        addressBcc.rightView = addBccBt as? UIView
                        addressBcc.rightViewMode = UITextFieldViewMode.WhileEditing
                        self._addressBcc = addressBcc
                        
                        self._addressBccDidLoad = true
                    }
                    
                    return cell
                case 3:
                    // セルを定義
                    var cell = tableView.dequeueReusableCellWithIdentifier("subjectCell") as TemplateEditTableViewCell
                    var subject = cell.viewWithTag(2) as UITextField
                    if (!self._subjectDidLoad) {
                        subject.text = object.mail_title
                        subject.delegate = self
                        
                        // キーボード上部にカスタムビューを表示
                        let window = ItemSelectSubjectWindow()
                        let keyBoard = KeyBoardViewOnTextField(frame: CGRectMake(0, 0, 320, 40))
                        keyBoard._textField = subject
                        keyBoard.drawKeyBoardView(self, window: window)
                        subject.inputAccessoryView = keyBoard
                        self._subject = subject
                        StringCommon.setTextFieldAttribute(false, key: self._ap.editTemplateName!, textField: self._subject)
                        
                        self._subjectDidLoad = true
                    }
                    
                    return cell
                case 4:
                    // セルを定義
                    var cell = TemplateEditTableViewCell()
                    if (!self._textDidLoad) {
                        self.textView.text = object.mail_body
                        StringCommon.setTextViewAttribute(false, key: self._ap.editTemplateName!, textView: self.textView)
                        
                        self._textDidLoad = true
                    }
                    
                    return cell
                    
                default:
                    // 空のセルを定義
                    var cell = UITableViewCell()
                    return cell
                }
            }
        }
        
        // 空のセルを定義
        var cell = UITableViewCell()
        return cell
    }
    
    // キーボード表示時イベント
    func keyboardShow(notification:NSNotification){
        
        // キーボード表示時に内容変更フラグをセットする
        if (!self._textChangeFlag) {
            self._textChangeFlag = true
        }
        
        // 送られてきたNSNotificationを処理して、キーボードの高さを取得する
        if let userInfo = notification.userInfo{
            if let keyboard = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue{
                self._keyBoardSize = keyboard.CGRectValue()
            }
        }
    }
    
    // キーボード非表示時イベント
    func keyboardHide(notification:NSNotification){
    }
    
    // テキスト変更時イベント
    func changeText(notification:NSNotification){
        
        // 本文(TextView)リサイズ
        if let keyBoardSize = self._keyBoardSize?.height {
            self.textView.resize(self._drawHeight! - keyBoardSize, width: self._drawWidth!)
        }
    }
    
    // TextView 編集開始時イベント処理
    func beginEditText(notification:NSNotification){
        
        // 本文(TextView)リサイズ
        if let keyBoardSize = self._keyBoardSize?.height {
            self.textView.resize(self._drawHeight! - keyBoardSize, width: self._drawWidth!)
        }
        
        // 本文(TextView)のTopが画面上端に来るよう全体をスクロール
        let section = tableView.numberOfSections()
        let index = tableView.numberOfRowsInSection(section - 1)
        var lastPath:NSIndexPath = NSIndexPath(forRow:index - 1, inSection:section - 1)

        self.tableView.scrollToRowAtIndexPath( lastPath , atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        
        // 編集中は本文の装飾を戻す
        let attrText = NSMutableAttributedString(string: textView.text)
        let str: NSString = self.textView.text
        let font = UIFont.systemFontOfSize(CGFloat(15))
        let range = NSMakeRange(0, str.length)
        attrText.addAttribute(NSFontAttributeName, value: font, range: range)
        attrText.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: range)
        textView.attributedText = attrText
    }
    
    // TextView 編集終了時イベント処理
    func endEditText(notification:NSNotification){
        
        if let keyBoard = self.textView.inputAccessoryView as? KeyBoardViewOnTextView {
            StringCommon.setTextViewAttribute(false, key: self._ap.editTemplateName!, textView: textView)
            keyBoard._window.hidden = true
        }
        
        // 本文(TextView)リサイズ
        self.textView.resize((self._drawHeight! - TemplateCell.withoutBodyHeight), width: (self._drawWidth! - 10.0))
    }
    
    // Saveボタン クリックイベント
    @IBAction func onClickSaveButton(sender: AnyObject) {
        
        // キーボードを閉じる
        self.view.endEditing(true)
        
        let okAct = UIAlertAction(title: "OK", style: .Default) {
            action in
            // テンプレートHEAD Key取得
            if let key = self._ap.editTemplateName {
                
                // テンプレートHEAD 更新用オブジェクト作成
                let templateHead: TemplateHead = TemplateHead()
                templateHead.template_name = key
                
                // アドレスTo取得
                if let addressTo = self._addressTo.text {
                    if (StringCommon.stringToArray(addressTo).count > 1) {
                        templateHead.mail_address_to = StringCommon.arrayToString(StringCommon.stringToArray(addressTo))
                    } else {
                        templateHead.mail_address_to = addressTo
                    }
                }
                
                // アドレスCc取得
                if let addressCc = self._addressCc.text {
                    if (StringCommon.stringToArray(addressCc).count > 1) {
                        templateHead.mail_address_cc = StringCommon.arrayToString(StringCommon.stringToArray(addressCc))
                    } else {
                        templateHead.mail_address_cc = addressCc
                    }
                }
                
                // アドレスBcc取得
                if let addressBcc = self._addressBcc.text {
                    if (StringCommon.stringToArray(addressBcc).count > 1) {
                        templateHead.mail_address_bcc = StringCommon.arrayToString(StringCommon.stringToArray(addressBcc))
                    } else {
                        templateHead.mail_address_bcc = addressBcc
                    }
                }
                
                // 件名取得
                if let subject = self._subject.text {
                    templateHead.mail_title = subject
                }
                
                // 本文取得
                if let body = self.textView.text {
                    templateHead.mail_body = body
                }
                
                // テンプレートHEAD 更新
                TemplateHead.updateTemplateHead(templateHead)
                
                self.dismissViewControllerAnimated(true, completion: nil)
                self._ap.editTemplateName = ""
            }
            return
        }
        ViewCommon.confirmDiarog(self, msg: "保存します。\nよろしいですか？", okAction: okAct, cancelAction: nil)
    }
    
    // Cancelボタン クリックイベント
    @IBAction func onClickCancelButton(sender: AnyObject) {
        
        // キーボードを閉じる
        self.view.endEditing(true)
        
        // 変更がなかった場合は確認なしで終了
        if (!self._textChangeFlag) {
            self.dismissViewControllerAnimated(true, completion: nil)
            self._ap.editTemplateName = ""
            self.view.endEditing(true)
            return
        }
        
        // OKボタン実装
        let okAct = UIAlertAction(title: "OK", style: .Default) {
            action in
            self.dismissViewControllerAnimated(true, completion: nil)
            self._ap.editTemplateName = ""
            return
        }
        ViewCommon.confirmDiarog(self, msg: "変更内容が破棄されます。\nよろしいですか？", okAction: okAct, cancelAction: nil)
    }
    
    // TextField 編集直後
    func textFieldDidBeginEditing(textField: UITextField){
        
        // 編集中は本文の装飾を戻す
        let attrText = NSMutableAttributedString(string: textField.text)
        let str: NSString = textField.text
        let font = UIFont.systemFontOfSize(CGFloat(14))
        let range = NSMakeRange(0, str.length)
        attrText.addAttribute(NSFontAttributeName, value: font, range: range)
        attrText.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: range)
        textField.attributedText = attrText
    }
    
    // TextField 編集完了後（完了直前）
    func textFieldDidEndEditing(textField: UITextField) -> Bool {
        if let keyBoard = textField.inputAccessoryView as? KeyBoardViewOnTextField {
            StringCommon.setTextFieldAttribute(false, key: self._ap.editTemplateName!, textField: textField)
            keyBoard._window.hidden = true
        }
        return true
    }
    
    // TextField内でreturnキーを押した時の動作
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let keyBoard = textField.inputAccessoryView as? KeyBoardViewOnTextField {
        } else {
            var str = textField.text
            if (!StringCommon.isBlank(str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))) {
                if (!str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).hasSuffix(";")) {
                    textField.text = "\(str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()));"
                }
            }
        }
        self.view.endEditing(true)
        return true
    }
    
    // アドレス(To)追加ボタン
    @IBAction func onClickAddToBt(){
        var peoplePicker = ABPeoplePickerView()
        peoplePicker.peoplePickerDelegate = self
        peoplePicker._textField = self._addressTo
        peoplePicker.displayedProperties = [NSNumber(int: kABPersonEmailProperty)]
        self.presentViewController(peoplePicker, animated: true, completion: nil)
        
        
        if peoplePicker.respondsToSelector(Selector("predicateForEnablingPerson")) {
            peoplePicker.predicateForEnablingPerson = NSPredicate(format: "emailAddresses.@count > 0")
        }
    }
    
    // アドレス(Cc)追加ボタン
    @IBAction func onClickAddCcBt(){
        var peoplePicker = ABPeoplePickerView()
        peoplePicker.peoplePickerDelegate = self
        peoplePicker._textField = self._addressCc
        peoplePicker.displayedProperties = [NSNumber(int: kABPersonEmailProperty)]
        self.presentViewController(peoplePicker, animated: true, completion: nil)
        
        if peoplePicker.respondsToSelector(Selector("predicateForEnablingPerson")) {
            peoplePicker.predicateForEnablingPerson = NSPredicate(format: "emailAddresses.@count > 0")
        }
    }
    
    // アドレス(Bcc)追加ボタン
    @IBAction func onClickAddBccBt(){
        var peoplePicker = ABPeoplePickerView()
        peoplePicker._textField = self._addressBcc
        peoplePicker.peoplePickerDelegate = self
        peoplePicker.displayedProperties = [NSNumber(int: kABPersonEmailProperty)]
        self.presentViewController(peoplePicker, animated: true, completion: nil)
        
        if peoplePicker.respondsToSelector(Selector("predicateForEnablingPerson")) {
            peoplePicker.predicateForEnablingPerson = NSPredicate(format: "emailAddresses.@count > 0")
        }
    }
    
    // アドレス帳でキャンセルボタンを押下時のイベント
    func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController!) {
        
        // アドレス帳を閉じる
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // アドレス帳からE-Mailアドレスが選択されたときのイベント
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerView!, didSelectPerson person: ABRecord!, property: ABPropertyID, identifier: ABMultiValueIdentifier) {
        let multiValue: ABMultiValueRef = ABRecordCopyValue(person, property).takeRetainedValue()
        let index = ABMultiValueGetIndexForIdentifier(multiValue, identifier)
        let email = ABMultiValueCopyValueAtIndex(multiValue, index).takeRetainedValue() as String
        
        if let buf = peoplePicker._textField?.text {
            if (!StringCommon.isBlank(buf)) {
                if let text = peoplePicker._textField?.text {
                    if text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).hasSuffix(";") {
                        peoplePicker._textField?.text = "\(buf)\(email);"
                    } else {
                        peoplePicker._textField?.text = "\(buf);\(email);"
                    }
                }
            } else {
                peoplePicker._textField?.text = "\(email);"
            }
        }
    }
}
