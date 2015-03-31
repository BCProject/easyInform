//
//  KeyBoardViewOnDatePickerView.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/29.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import UIKit

class KeyBoardViewOnDatePickerView: UIView {

    var _nowButton = UIButton()
    var _datePicker = UIDatePicker()
    var _textField = UITextField()
    
    // Appデリゲートオブジェクト
    let _ap:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    func drawKeyBoardView(textField: UITextField, datePicker: UIDatePicker)  {
        
        // オブジェクトサイズ設定
        self._nowButton = UIButton(frame: CGRectMake(10, 5, 40, 30))
        
        // キーボードビュー作成
        self.backgroundColor = UIColor.BackColor()
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.BorderColor().CGColor
        
        // アイテムボタン作成
        self._nowButton.setTitle("現在", forState: UIControlState.Normal)
        self._nowButton.setTitleColor(UIColor.MainColor(), forState: .Normal)
        self._nowButton.addTarget(self, action: "onClickNowButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        // ボタンをビューに追加
        self.addSubview(self._nowButton)
        self._datePicker = datePicker
        self._textField = textField
    }
    
    // 現在ボタン クリックイベント
    func onClickNowButton() {
        self._datePicker.date = NSDate()
        self._textField.text = self.dateToString(date)
    }
}
