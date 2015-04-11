//
//  ItemSelectPickerView.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/22.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import UIKit
import Realm

class ItemSelectPickerView: UIPickerView, UIPickerViewDelegate {

    // 変数
    var _itemData: RLMArray?
    let _defaultMessage: String = "データ無し"
    
    // Appデリゲートオブジェクト
    let _ap:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        self.backgroundColor = UIColor.BackColor()
        self.tintColor = UIColor.MainColor()
        self.showsSelectionIndicator = true
        
        // デリゲート
        self.delegate = self
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        var count: UInt = 1
        if let itemData = self._itemData {
            if (itemData.count > 0) {
                count = itemData.count
            }
        }
        return Int(count)
    }
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedString = NSAttributedString(string: _defaultMessage, attributes: [NSForegroundColorAttributeName : UIColor.MainColor()])
        if let itemData = self._itemData {
            if (itemData.count > 0) {
                attributedString = NSAttributedString(string: "{\((itemData[UInt(row)] as TemplateItem).item_title)}", attributes: [NSForegroundColorAttributeName : UIColor.MainColor()])
            }
        }
        return attributedString
    }
}
