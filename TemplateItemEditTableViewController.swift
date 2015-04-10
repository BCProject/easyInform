//
//  TemplateItemEditTableViewController.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/04/08.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import UIKit

struct ItemCell {
    static let section: [String] = ["アイコン","タイプ","フォーマット","内容"]
    static let itemTypeHeight: CGFloat = 40.0
    static let formatHeight: CGFloat = 40.0
    static let iconHeight: CGFloat = 50.0
    static let contentHeight: CGFloat = 40.0
    static let withoutBodyHeight: CGFloat = 170.0
    static let contentSection: NSInteger = 3
    static let rowCount: NSInteger = 4
}

class TemplateItemEditTableViewController: UITableViewController,  UITextFieldDelegate {
    
    var _dateFlg: Bool = false
    
    // Appデリゲートオブジェクト
    let _ap:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self._ap.editItemTitle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.tableFooterView = UIView(frame: CGRectMake(0, 0, 0, 0))
        self.tableView.reloadData()
        
        // ****************************************//
        // For Debug...
        if (!self._ap.hideBanner) {
            self.canDisplayBannerAds = true
        } else {
            self.canDisplayBannerAds = false
        }
        // ****************************************//
    }
    
    // アイテム作成画面 テキストフィールドオブジェクト
    var _itemType = NoMenuTextField()
    var _itemTypeDidLoad = false
    var _format = NoMenuTextField()
    var _formatDidLoad = false
    var _icon = UISegmentedControl()
    var _iconDidLoad = false
    var _content = UILabel()
    var _contentDidLoad = false
    var _itemTypeWork = ItemType.TEXT
    var _itemFormatWork = ItemFormat.NONE
    var _typePicker = CustomPickerView()
    var _formatPicker = CustomPickerView()
    
    // テーブルセル行幅
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section) {
        case 0:
            return ItemCell.iconHeight
        case 1:
            return ItemCell.itemTypeHeight
        case 2:
            return ItemCell.formatHeight
        case 3:
            return ItemCell.contentHeight
        default:
            return 0.0
        }
    }
    
    // セクションタイトル
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ItemCell.section[section]
    }
    
    // セクション数
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return ItemCell.section.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // テーブルセル 内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let key = self._ap.editItemNo {
            
            // テンプレートITEM情報取得
            if let object = TemplateItem.objectsWhere("item_no = \(key)").firstObject() as? TemplateItem {
                switch (indexPath.section) {
                case 0:
                    // セルを定義
                    var cell = tableView.dequeueReusableCellWithIdentifier("iconCell") as TemplateEditTableViewCell
                    var icon = cell.viewWithTag(2) as UISegmentedControl
                    if (!self._iconDidLoad) {
                        icon.selectedSegmentIndex = object.item_image - 1
                        self._icon = icon
                        self._iconDidLoad = true
                    }
                    
                    return cell
                    
                case 1:
                    // セルを定義
                    var cell = tableView.dequeueReusableCellWithIdentifier("itemTypeCell") as TemplateEditTableViewCell
                    if (!self._itemTypeDidLoad) {
                        var itemType = cell.viewWithTag(2) as NoMenuTextField
                        itemType.text = ItemType.TYPE[object.item_type]
                        self._itemTypeWork = object.item_type
                        
                        self._typePicker.setData(ItemType.TYPE, textField: itemType, vc: self)
                        self._typePicker.selectRow(object.item_type - 1, inComponent: 0, animated: true)
                        
                        // キーボードビュー作成
                        let keyBoard = UIView(frame: CGRectMake(0, 0, 320, 40))
                        keyBoard.backgroundColor = UIColor.BackColor()
                        keyBoard.layer.borderWidth = 0.5
                        keyBoard.layer.borderColor = UIColor.BorderColor().CGColor
                        
                        // アイテムボタン作成
                        let doneButton = UIButton(frame: CGRectMake((CGRectGetWidth(self.view.frame) - 50), 5, 50, 30))
                        doneButton.setTitle("完了", forState: UIControlState.Normal)
                        doneButton.setTitleColor(UIColor.MainColor(), forState: .Normal)
                        doneButton.addTarget(self, action: "onClickDoneBt", forControlEvents: UIControlEvents.TouchUpInside)
                        
                        // ボタンをビューに追加
                        keyBoard.addSubview(doneButton)
                        itemType.inputView = self._typePicker
                        itemType.inputAccessoryView = keyBoard
                        
                        self._itemType = itemType
                        itemType.delegate = self
                        
                        self._itemTypeDidLoad = true
                    }
                    
                    return cell
                    
                case 2:
                    // セルを定義
                    var cell = tableView.dequeueReusableCellWithIdentifier("formatCell") as TemplateEditTableViewCell
                    var format = cell.viewWithTag(2) as NoMenuTextField
                    
                    // 余分な候補を削除
                    if (!self._formatDidLoad){
                        format.text = ItemFormat.FORMAT[object.item_format]
                        self._itemFormatWork = object.item_format
                        
                        switch(self._itemTypeWork){
                        case ItemType.DATE:
                            self._formatPicker.setData([String](ItemFormat.FORMAT[ItemFormat.DATE]), textField: format, vc: self)
                            self._formatPicker.selectRow(object.item_format + ItemFormat.DATE_OFFSET, inComponent: 0, animated: true)
                            break
                        case ItemType.DATETIME:
                            self._formatPicker.setData([String](ItemFormat.FORMAT[ItemFormat.DATETIME]), textField: format, vc: self)
                            self._formatPicker.selectRow(object.item_format + ItemFormat.DATETIME_OFFSET, inComponent: 0, animated: true)
                            break
                        case ItemType.TIME:
                            self._formatPicker.setData([String](ItemFormat.FORMAT[ItemFormat.TIME]), textField: format, vc: self)
                            self._formatPicker.selectRow(object.item_format + ItemFormat.TIME_OFFSET, inComponent: 0, animated: true)
                            break
                        case ItemType.TEXT:
                            self._formatPicker.setData([String](ItemFormat.FORMAT[ItemFormat.TEXT]), textField: format, vc: self)
                            self._formatPicker.selectRow(object.item_format + ItemFormat.TEXT_OFFSET, inComponent: 0, animated: true)
                            break
                        default:
                            self._formatPicker.setData(ItemFormat.FORMAT, textField: format, vc: self)
                            self._formatPicker.selectRow(object.item_format + ItemFormat.DATE_OFFSET, inComponent: 0, animated: true)
                            break
                        }
                    
                        // キーボードビュー作成
                        let keyBoard = UIView(frame: CGRectMake(0, 0, 320, 40))
                        keyBoard.backgroundColor = UIColor.BackColor()
                        keyBoard.layer.borderWidth = 0.5
                        keyBoard.layer.borderColor = UIColor.BorderColor().CGColor
                        
                        // アイテムボタン作成
                        let doneButton = UIButton(frame: CGRectMake((CGRectGetWidth(self.view.frame) - 50), 5, 50, 30))
                        doneButton.setTitle("完了", forState: UIControlState.Normal)
                        doneButton.setTitleColor(UIColor.MainColor(), forState: .Normal)
                        doneButton.addTarget(self, action: "onClickDoneBt", forControlEvents: UIControlEvents.TouchUpInside)
                        
                        // ボタンをビューに追加
                        keyBoard.addSubview(doneButton)
                        format.inputView = self._formatPicker
                        format.inputAccessoryView = keyBoard
                        
                        self._format = format
                        format.delegate = self
                    
                        self._formatDidLoad = true
                    }
                    
                    return cell
                case 3:
                    // セルを定義
                    var cell = tableView.dequeueReusableCellWithIdentifier("contentCell") as TemplateEditTableViewCell
                    if (!self._contentDidLoad){
                        var content = cell.viewWithTag(2) as UILabel
                        content.text = object.item_content
                        self._content = content
                        
                        self._contentDidLoad = true
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
    
    // Cell 選択イベント
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.view.endEditing(true)
        
        if (indexPath.section == ItemCell.contentSection) {
            switch(self._itemTypeWork) {
            case ItemType.DATE:
                StringCommon.inputDateDialog(self._ap.editItemTitle!, contents: self._content.text!, df: StringCommon.setTextFieldInputType(self._itemFormatWork)!, vc: self)
                break
            case ItemType.DATETIME:
                StringCommon.inputDateTimeDialog(self._ap.editItemTitle!, contents: self._content.text!, df: StringCommon.setTextFieldInputType(self._itemFormatWork)!, vc: self)
                break
            case ItemType.TIME:
                StringCommon.inputTimeDialog(self._ap.editItemTitle!, contents: self._content.text!, df: StringCommon.setTextFieldInputType(self._itemFormatWork)!, vc: self)
                break
            case ItemType.TEXT:
                StringCommon.inputTextDialog(self._ap.editItemTitle!, contents: self._content.text!, vc: self)
                break
            default:
                break
            }
        }
        
        // 選択解除
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if (indexPath.section == ItemCell.contentSection) {
            return indexPath
        } else {
            return nil
        }
    }
    
    // TextField内でreturnキーを押した時の動作
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    // TEXT編集時イベント
    func textFieldDidBeginEditing(textField: UITextField) {
        switch (textField) {
        default:
            break
        }
    }
    
    // TEXT編集完了時イベント
    func textFieldDidEndEditing(textField: UITextField) {
        switch (textField) {
        case self._itemType:
            self.tableView.reloadData()
            self.view.endEditing(true)
            break
        case self._format:
            self.tableView.reloadData()
            self.view.endEditing(true)
            break
        default:
            break
        }
    }
    
    // 完了ボタン押下
    func onClickDoneBt() {
        self.view.endEditing(true)
    }
    
    // 入力完了後
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(true)
        
        // テンプレートITEM Key取得
        if let key = self._ap.editItemNo {
            
            // テンプレートHEAD 更新用オブジェクト作成
            let templateItem: TemplateItem = TemplateItem()
            templateItem.item_no = key
            
            // アイテム名取得
            if let itemName = self._ap.editItemTitle {
                templateItem.item_title = itemName
            }
            
            // アイコン取得
            templateItem.item_image = self._icon.selectedSegmentIndex + 1
            
            // タイプ取得
            templateItem.item_type = self._itemTypeWork
            
            // フォーマット取得
            templateItem.item_format = self._itemFormatWork
            
            // 内容取得
            if let content = self._content.text {
                templateItem.item_content = content
            }
            
            // テンプレートHEAD 更新
            TemplateItem.updateTemplateItem(templateItem)
        }
    }

}
