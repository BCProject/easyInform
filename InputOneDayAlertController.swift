//
//  InputOneDayAlertController.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/28.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import UIKit

class InputOneDayAlertController: UIAlertController {

    // 入力フォーム用変数
    var _textField1 = UITextField()
    var _datePicker = UIDatePicker()
    
    var _placeholder1: String = ""
    
    var _text1: String = ""
    
    var _ap:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // キャンセルボタン作成
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .Cancel) { action -> Void in
            return
        }
        
        // 入力フォーム1をアラートにセット
        self.addTextFieldWithConfigurationHandler { textField -> Void in
            self._textField1 = textField
            textField.placeholder = self._placeholder1
            textField.text = self._text1
            self._datePicker.addTarget(self, action: "changedDateEvent:", forControlEvents: UIControlEvents.ValueChanged)
            self._datePicker.datePickerMode = UIDatePickerMode.Date
            textField.inputView = self._datePicker
            
            // キーボードビュー作成
            let keyBoard = UIView(frame: CGRectMake(0, 0, 320, 40))
            keyBoard.backgroundColor = UIColor.BackColor()
            keyBoard.layer.borderWidth = 0.5
            keyBoard.layer.borderColor = UIColor.BorderColor().CGColor
            
            // アイテムボタン作成
            let nowButton = UIButton(frame: CGRectMake(10, 5, 40, 30))
            nowButton.setTitle("現在", forState: UIControlState.Normal)
            nowButton.setTitleColor(UIColor.MainColor(), forState: .Normal)
            nowButton.addTarget(self, action: "onClickNowBt", forControlEvents: UIControlEvents.TouchUpInside)
            
            // ボタンをビューに追加
            keyBoard.addSubview(nowButton)
            textField.inputAccessoryView = keyBoard
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTextFieldOption (placeholder1: String, text1: String) {
        self._placeholder1 = placeholder1
        self._text1 = text1
    }
    
    // 「現在」を押すと今日の日付をセットする
    func onClickNowBt() {
        self._datePicker.date = NSDate()
        changeLabelDate(NSDate())
    }
    
    //
    func changedDateEvent(sender:AnyObject?){
        var dateSelecter: UIDatePicker = sender as UIDatePicker
        self.changeLabelDate(self._datePicker.date)
    }
    
    func changeLabelDate(date:NSDate) {
        self._textField1.text = self.dateToString(date)
    }
    
    func dateToString(date:NSDate) ->String {
        let calender: NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        let comps: NSDateComponents = calender.components(NSCalendarUnit.YearCalendarUnit|NSCalendarUnit.MonthCalendarUnit|NSCalendarUnit.DayCalendarUnit|NSCalendarUnit.HourCalendarUnit|NSCalendarUnit.MinuteCalendarUnit|NSCalendarUnit.SecondCalendarUnit|NSCalendarUnit.WeekdayCalendarUnit, fromDate: date)
        
        var date_formatter: NSDateFormatter = NSDateFormatter()
        var weekdays: Array  = ["", "日", "月", "火", "水", "木", "金", "土"]
        
        date_formatter.locale     = NSLocale(localeIdentifier: "ja")
        date_formatter.dateFormat = "(\(weekdays[comps.weekday]))"
        
        return date_formatter.stringFromDate(date)
    }

}
