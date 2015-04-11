//
//  KeyBoardViewOnTextField.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/22.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import UIKit
import Realm

class KeyBoardViewOnTextField: UIView {
    
    var _viewController = TemplateEditTableViewController()
    var _segmentControll = UISegmentedControl()
    var _doneButton = UIButton()
    var _selectButton = UIButton()
    var _textField = UITextField()
    var _textBackup:String = ""
    let _list = ItemSelectPickerView()
    var _itemData: RLMArray?
    var _isItem = false
    
    // Appデリゲートオブジェクト
    let _ap:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    func drawKeyBoardView(view: TemplateEditTableViewController)  {
        
        // テンプレートITEMデータ設定
        if let key = self._ap.editTemplateName {
            self._itemData = TemplateItem.selectAllTemplateItem(key)
            self._list._itemData = TemplateItem.selectAllTemplateItem(key)
        }
        
        // キーボードビュー作成
        self.backgroundColor = UIColor.BackColor()
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.BorderColor().CGColor
        
        // セグメントコントロール作成
        let segArr: [String] = ["DEFAULT","ITEM"]
        self._segmentControll = UISegmentedControl(items: segArr)
        self._segmentControll.frame = CGRectMake(10, 5, 160, 30)
        self._segmentControll.selectedSegmentIndex = 0
        self._segmentControll.tintColor = UIColor.MainColor()
        self._segmentControll.addTarget(self, action: "changeSegment", forControlEvents: UIControlEvents.ValueChanged)
        
        // 完了ボタン作成
        self._doneButton = UIButton(frame: CGRectMake((self._ap.statusBarWidth! - 50), 5, 50, 30))
        self._doneButton.setTitle("完了", forState: UIControlState.Normal)
        self._doneButton.setTitleColor(UIColor.MainColor(), forState: .Normal)
        self._doneButton.addTarget(self, action: "onClickColoseButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        // 選択ボタン作成
        self._selectButton = UIButton(frame: CGRectMake((self._ap.statusBarWidth! - 100), 5, 50, 30))
        self._selectButton.setTitle("選択", forState: UIControlState.Normal)
        self._selectButton.setTitleColor(UIColor.MainColor(), forState: .Normal)
        self._selectButton.addTarget(self, action: "onClickSelectButton", forControlEvents: UIControlEvents.TouchUpInside)
        self._selectButton.hidden = true
        
        // ボタンをビューに追加
        self.addSubview(self._segmentControll)
        self.addSubview(self._doneButton)
        self.addSubview(self._selectButton)
        
        self._viewController = view
    }
    
    // セグメントコントロール変更イベント
    func changeSegment() {
        var position: UITextPosition?
        if let range = self._textField.selectedTextRange {
            position = self._textField.positionFromPosition(range.start, offset: 0)
        }
        self._textField.resignFirstResponder()
        if (!self._isItem) {
            self._segmentControll.selectedSegmentIndex = 1
            self._textField.inputView = self._list
            
            // 選択ボタン表示処理
            if let isData = self._itemData {
                if isData.count > 0 {
                    self._selectButton.hidden = false
                } else {
                    self._selectButton.hidden = true
                }
            } else {
                self._selectButton.hidden = true
            }
            self._isItem = true
        } else {
            self._segmentControll.selectedSegmentIndex = 0
            self._textField.inputView = nil
            self._selectButton.hidden = true
            self._isItem = false
        }
        self._textField.becomeFirstResponder()
        
        if let pos = position {
            self._textField.selectedTextRange = self._textField.textRangeFromPosition(pos, toPosition: pos)
        }
    }
    
    // 完了ボタン クリックイベント
    func onClickColoseButton() {
        self._viewController.view.endEditing(true)
    }
    
    // 選択ボタン クリックイベント
    func onClickSelectButton() {
        let index = self._list.selectedRowInComponent(0)
        var paste: UIPasteboard = UIPasteboard.generalPasteboard()
        var text: NSString = ""
        if let buf = paste.string {
            text = buf
        }
        if let itemData = self._itemData {
            paste.string = "{\((itemData[UInt(index)] as TemplateItem).item_title)}"
        }
        self._textField.paste(paste)
        paste.string = text
    }
}
