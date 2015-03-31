//
//  UIDatePickerTextField.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/14.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import Foundation
import UIKit

public class UIDatePickerTextField: UITextField {
    
    override public func awakeFromNib() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleFocused:"), name: UITextFieldTextDidBeginEditingNotification, object: nil)
    }
    
    public func handleFocused(notification: NSNotification!) {
        var datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        self.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    public func handleDatePicker(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        super.text = dateFormatter.stringFromDate(sender.date)
    }
}