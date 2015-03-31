//
//  ItemSelectSubjectWindow.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/22.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import UIKit
import Realm

class ItemSelectSubjectWindow: UIWindow {
    
    // ダイアログ
    var _textField = UITextField()
    var _viewController = TemplateEditTableViewController()
    let _titleTabel = ItemSelectLabel()
    let _addButton: AnyObject = UIButton.buttonWithType(UIButtonType.ContactAdd)
    let _doneButton = CustomButton()
    let _list = ItemSelectPickerView()
    var _itemData: RLMArray?
    
    // Appデリゲートオブジェクト
    let _ap:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    // ダイアログ表示
    func drawItemSelectWindow (vc: TemplateEditTableViewController, textField: UITextField, drawX: CGFloat, drawY: CGFloat) {
        
        // テンプレートITEMデータ設定
        if let key = self._ap.editTemplateName {
            self._itemData = TemplateItem.selectAllTemplateItem(key)
            self._list._itemData = TemplateItem.selectAllTemplateItem(key)
        }
        
        // 背景色を設定する
        self.backgroundColor = UIColor.BackColor()
        self.frame = CGRectMake(0.0, 0.0, 200.0, 222.0)
        self.layer.position = CGPointMake(drawX, drawY)
        self.alpha = 0.9
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.BorderColor().CGColor
        
        // ダイアログを表示
        self.makeKeyWindow()
        self.makeKeyAndVisible()
        
        // ラベルを作成する
        _titleTabel.frame = CGRectMake(0, 0, 160, 40)
        _titleTabel.text = "アイテム選択"
        _titleTabel.layer.position = CGPointMake(self.frame.width/2, self.frame.height - 202.0)
        self.addSubview(_titleTabel)
        
        // Picker Viewを作成する
        if let height = self._ap.navBarHeight {
            _list.layer.position = CGPointMake(self.frame.width/2, self.frame.height/2)
        }
        self.addSubview(_list)
        
        // ボタンを作成する
        _doneButton.frame = CGRectMake(0, 0, 60, 30)
        _doneButton.backgroundColor = UIColor.MainColor()
        _doneButton.setTitle("選択", forState: .Normal)
        _doneButton.layer.position = CGPointMake(self.frame.width/2, self.frame.height-30)
        _doneButton.addTarget(self, action: "onClickDoneSubjectButton", forControlEvents: .TouchUpInside)
        self.addSubview(_doneButton)
        
        self._textField = textField
        self._viewController = vc
    }
    
    func onClickDoneSubjectButton() {
        let index = self._list.selectedRowInComponent(0)
        var paste: UIPasteboard = UIPasteboard.generalPasteboard()
        var text: NSString = ""
        if let buf = paste.string {
            text = buf
        }
        if let itemData = self._itemData {
            if (itemData.count > 0) {
                paste.string = "{\((itemData[UInt(index)] as TemplateItem).item_title)}"
            } else {
                self.hidden = true
                return
            }
        }
        self._textField.paste(paste)
        paste.string = text
        self.hidden = true
    }
}
