//
//  InputTwoTextAlertController.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/22.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import UIKit

class InputTwoTextAlertController: UIAlertController {

    // 入力フォーム用変数
    var _textField1 = UITextField()
    var _textField2 = UITextField()
    
    var _placeholder1: String = ""
    var _placeholder2: String = ""
    
    var _text1: String = ""
    var _text2: String = ""
    
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
        }
        
        // 入力フォーム2をアラートにセット
        self.addTextFieldWithConfigurationHandler { textField -> Void in
            self._textField2 = textField
            textField.placeholder = self._placeholder2
            textField.text = self._text2
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTextFieldOption (placeholder1: String, placeholder2: String, text1: String, text2: String) {
        self._placeholder1 = placeholder1
        self._placeholder2 = placeholder2
        self._text1 = text1
        self._text2 = text2
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
