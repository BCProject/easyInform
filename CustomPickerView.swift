//
//  CustomPickerView.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/04/09.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import UIKit

class CustomPickerView: UIPickerView , UIPickerViewDelegate {
    
    // 変数
    var _data = [String]()
    var _textField = NoMenuTextField()
    var _vc = UITableViewController()
    
    // Appデリゲートオブジェクト
    let _ap:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        self.backgroundColor = UIColor.BackColor()
        self.tintColor = UIColor.MainColor()
        self.showsSelectionIndicator = true
    }
    
    func setData(data: [String], textField: NoMenuTextField, vc: TemplateItemEditTableViewController) {
        
        self._data = data
        self._textField = textField
        self._vc = vc
        
        // デリゲート
        self.delegate = self
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        var count: Int = 1
        if (self._data.count > 0) {
            count = self._data.count - 1
        }
        return count
    }
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedString = NSAttributedString(string: "", attributes: [NSForegroundColorAttributeName : UIColor.MainColor()])
        if (self._data.count > 0) {
            attributedString = NSAttributedString(string: "\(self._data[Int(row + 1)])", attributes: [NSForegroundColorAttributeName : UIColor.MainColor()])
        }
        return attributedString
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self._textField.text = self._data[row + 1]
        if let vc = self._vc as? TemplateItemEditTableViewController {
            if (self._data == ItemType.TYPE) {
                vc._itemTypeWork = row + 1
                    switch(vc._itemTypeWork){
                    case ItemType.DATE:
                        vc._formatPicker.setData([String](ItemFormat.FORMAT[ItemFormat.DATE]), textField: vc._format, vc: vc)
                        vc._formatPicker.selectRow(0, inComponent: 0, animated: true)
                        vc._format.text = ItemFormat.FORMAT[-ItemFormat.DATE_OFFSET]
                        vc._itemFormatWork = -ItemFormat.DATE_OFFSET
                        break
                    case ItemType.DATETIME:
                        vc._formatPicker.setData([String](ItemFormat.FORMAT[ItemFormat.DATETIME]), textField: vc._format, vc: vc)
                        vc._formatPicker.selectRow(0, inComponent: 0, animated: true)
                        vc._format.text = ItemFormat.FORMAT[-ItemFormat.DATETIME_OFFSET]
                        vc._itemFormatWork = -ItemFormat.DATETIME_OFFSET
                        break
                    case ItemType.TIME:
                        vc._formatPicker.setData([String](ItemFormat.FORMAT[ItemFormat.TIME]), textField: vc._format, vc: vc)
                        vc._formatPicker.selectRow(0, inComponent: 0, animated: true)
                        vc._format.text = ItemFormat.FORMAT[-ItemFormat.TIME_OFFSET]
                        vc._itemFormatWork = -ItemFormat.TIME_OFFSET
                        break
                    case ItemType.TEXT:
                        vc._formatPicker.setData([String](ItemFormat.FORMAT[ItemFormat.TEXT]), textField: vc._format, vc: vc)
                        vc._formatPicker.selectRow(0, inComponent: 0, animated: true)
                        vc._format.text = ItemFormat.FORMAT[-ItemFormat.TEXT_OFFSET]
                        vc._itemFormatWork = -ItemFormat.TEXT_OFFSET
                        break
                    default:
                        vc._formatPicker.setData(ItemFormat.FORMAT, textField: vc._format, vc: vc)
                        vc._formatPicker.selectRow(0, inComponent: 0, animated: true)
                        vc._format.text = ItemFormat.FORMAT[-ItemFormat.DATE_OFFSET]
                        vc._itemFormatWork = -ItemFormat.DATE_OFFSET
                        break
                    }
            } else if (self._data == [String](ItemFormat.FORMAT[ItemFormat.DATE])) {
                vc._itemFormatWork = row - ItemFormat.DATE_OFFSET
            } else if (self._data == [String](ItemFormat.FORMAT[ItemFormat.DATETIME])) {
                vc._itemFormatWork = row - ItemFormat.DATETIME_OFFSET
            } else if (self._data == [String](ItemFormat.FORMAT[ItemFormat.TIME])) {
                vc._itemFormatWork = row - ItemFormat.TIME_OFFSET
            } else if (self._data == [String](ItemFormat.FORMAT[ItemFormat.TEXT])) {
                vc._itemFormatWork = row - ItemFormat.TEXT_OFFSET
            }
        }
    }
}
