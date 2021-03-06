//
//  InputOneTextAlertController.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/22.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import UIKit

class InputOneTextAlertController: UIAlertController {
    
    // 入力フォーム用変数
    var _textField1 = UITextField()
    
    var _placeholder1: String = ""
    
    var _text1: String = ""
    
    var _notification = NSNotificationCenter.defaultCenter()
    
    var _ap:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 入力フォーム1をアラートにセット
        self.addTextFieldWithConfigurationHandler { textField -> Void in
            self._textField1 = textField
            textField.clearButtonMode = UITextFieldViewMode.WhileEditing
            textField.placeholder = self._placeholder1
            textField.text = self._text1
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
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
