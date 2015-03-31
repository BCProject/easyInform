//
//  KeyBoardViewOnTextView.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/22.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import UIKit

class KeyBoardViewOnTextView: UIView, UITextViewDelegate {
    
    var _viewController = UIViewController()
    var _window = ItemSelectWindow()
    var _itemButton = UIButton()
    var _doneButton = UIButton()
    var _longPressRecognizer = UILongPressGestureRecognizer()
    var _textView = UITextView()
    var _textBackup:String = ""
    var _textLength:Int = 0
    
    // Appデリゲートオブジェクト
    let _ap:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    func drawKeyBoardView(view: UIViewController, window: ItemSelectWindow) {

        // オブジェクトサイズ設定
        self._itemButton = UIButton(frame: CGRectMake(10, 5, 40, 30))
        self._doneButton = UIButton(frame: CGRectMake((self._ap.statusBarWidth! - 50), 5, 50, 30))
        
        // LongPressRecognizer設定
        self._longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "itemButtonAction:")
        self._longPressRecognizer.allowableMovement = 15
        self._longPressRecognizer.minimumPressDuration = 0.2
        
        // キーボードビュー作成
        self.backgroundColor = UIColor.BackColor()
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.BorderColor().CGColor
        
        // アイテムボタン作成
        self._itemButton.setTitle("item", forState: UIControlState.Normal)
        self._itemButton.setTitleColor(UIColor.MainColor(), forState: .Normal)
        self._itemButton.addTarget(self, action: "onClickItemButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        // 完了ボタン作成
        self._doneButton.setTitle("完了", forState: UIControlState.Normal)
        self._doneButton.setTitleColor(UIColor.MainColor(), forState: .Normal)
        self._doneButton.addTarget(self, action: "onClickColoseButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        // ボタンをビューに追加
        self.addSubview(self._itemButton)
        self.addSubview(self._doneButton)
        self.addGestureRecognizer(self._longPressRecognizer)
        
        self._viewController = view
        self._window = window
    }

    // 長押し判別用
    @IBAction func itemButtonAction(gestureRecognizer: UILongPressGestureRecognizer){
        
        // 座標オブジェクト(タップした座標を格納)
        let p: CGPoint = gestureRecognizer.locationInView(self)
        
        // 現在のキャレットを保存
        let range: UITextRange = self._textView.selectedTextRange!
        
        // itemボタンをタップしていた場合は処理開始
        if (p.x >= 10 && p.x <= 100) {
            let textLength = self._textLength
            if (gestureRecognizer.state == UIGestureRecognizerState.Began) {
                self._textBackup = self._textView.text
                if let key = self._ap.editTemplateName {
                    self._textView.text = MaillerCommon.createSentence(key, str: self._textView.text)
                }
            } else {
                self._textView.text = self._textBackup
            }
        }
    }
    
    // アイテムボタン クリックイベント
    func onClickItemButton() {
        if (self._window.hidden) {
            self._window.drawItemSelectWindow(self._viewController, textView: self._textView, drawX: self._viewController.view.frame.width/2, drawY: self._viewController.view.frame.height/2 - 120.0)
        } else {
            self._window.hidden = true
        }
    }
    
    // 完了ボタン クリックイベント
    func onClickColoseButton() {
        self._viewController.view.endEditing(true )
        self._window.hidden = true
    }
    
    // 文字数カウント
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        // 入力済みの文字と入力された文字を合わせて取得
        var str = self._textView.text + text
        self._textLength = countElements("\(str)")
        return true
    }
}
