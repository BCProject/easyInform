//
//  Common.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/18.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import Foundation

struct ItemType {
    static let DATE_YYYYMMDD_SLA: NSInteger = 1
    static let DATE_YYYYMMDD_JA: NSInteger = 2
    static let DATE_YYYYMMDD_HI: NSInteger = 3
    static let DATE_YYYYMM_SLA: NSInteger = 4
    static let DATE_YYYYMM_JA: NSInteger = 5
    static let DATE_YYYYMM_HI: NSInteger = 6
    static let DATE_MMDD_SLA: NSInteger = 7
    static let DATE_MMDD_JA: NSInteger = 8
    static let DATE_MMDD_HI: NSInteger = 9
    static let DATE_MD_SLA: NSInteger = 10
    static let DATE_MD_JA: NSInteger = 11
    static let DATE_MD_HI: NSInteger = 12
    static let DATETIME_MMDD_HHMM_COL: NSInteger = 13
    static let DATETIME_MMDD_HHMM_JA: NSInteger = 14
    static let DATETIME_MD_HMM_COL: NSInteger = 15
    static let DATETIME_MD_HMM_JA: NSInteger = 16
    static let TIME_HHMM_COL: NSInteger = 17
    static let TIME_HHMM_JA: NSInteger = 18
    static let TIME_HMM_COL: NSInteger = 19
    static let TIME_HMM_JA: NSInteger = 20
    static let DAY: NSInteger = 21
    static let TEXTFIELD: NSInteger = 22
}

struct ItemImage {
    static let DATE: NSString = "calendar"
    static let DATETIME: NSString = "calendars"
    static let TIME: NSString = "time"
    static let NOTE: NSString = "note"
    static let REASON: NSString = "reason"
}

// 文字列操作関係
struct StringCommon {

    // 空白チェック
    static func isBlank(str: String) -> Bool {
        var result: Bool = false
        if (str == "") {
            result = true
        }
        return result
    }
    
    // 文字列配列を文字列に変換
    static func arrayToString(array: [String]) -> String {
        var result: String = ""
        if (array.count > 0) {
            for arr in array {
                if (!StringCommon.isBlank(result)) {
                    result = "\(result);\(arr)"
                } else {
                    result = "\(arr)"
                }
            }
        }
        return result
    }
    
    // 文字列を文字列配列に変換
    static func stringToArray(str: String) -> [String] {
        var result: [String] = []
        if (!self.isBlank(str)) {
            var array = str.componentsSeparatedByString(";")
            for buf in array {
                let appendStr = buf.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                if (!StringCommon.isBlank(appendStr)) {
                    result.append(appendStr)
                }
            }
        }
        return result
    }
    
    // TextView 装飾
    static func setTextViewAttribute(isContent: Bool, key: String, textView: UITextView) {
        let attrText = NSMutableAttributedString(string: textView.text)
        let str: NSString = textView.text
        let font = UIFont.systemFontOfSize(CGFloat(15))
        let range = NSMakeRange(0, str.length)
        attrText.addAttribute(NSFontAttributeName, value: font, range: range)
        
        // テンプレートITEMデータ設定
        if let itemData = TemplateItem.selectAllTemplateItem(key) {
            if (itemData.count > 0) {
                for (var i = 0; i < Int(itemData.count); i++){
                    var currentRange: NSRange = NSMakeRange(0, str.length)
                    
                    while (currentRange.location != NSNotFound) {
                        var title = ""
                        if (!isContent) {
                            title = "{\((itemData[UInt(i)] as TemplateItem).item_title)}"
                        } else {
                            title = "\((itemData[UInt(i)] as TemplateItem).item_content)"
                        }
                        currentRange = str.rangeOfString(title, options: NSStringCompareOptions.LiteralSearch, range: currentRange)
                        if(currentRange.location != NSNotFound) {
                            attrText.addAttribute(NSForegroundColorAttributeName, value: UIColor.MainColor(), range: str.rangeOfString(title, options: NSStringCompareOptions.LiteralSearch, range: currentRange))
                            textView.attributedText = attrText
                            var from: Int = currentRange.location + (title as NSString).length
                            var end: Int = str.length - from
                            currentRange = NSMakeRange(from, end)
                        }
                    }
                }
            } else {
                return
            }
        }
    }
    
    // TextField 装飾
    static func setTextFieldAttribute(isContent: Bool, key: String, textField: UITextField) {
        let attrText = NSMutableAttributedString(string: textField.text)
        let str: NSString = textField.text
        let font = UIFont.systemFontOfSize(CGFloat(14))
        let range = NSMakeRange(0, str.length)
        attrText.addAttribute(NSFontAttributeName, value: font, range: range)
        
        // テンプレートITEMデータ設定
        if let itemData = TemplateItem.selectAllTemplateItem(key) {
            if (itemData.count > 0) {
                for (var i = 0; i < Int(itemData.count); i++){
                    var currentRange: NSRange = NSMakeRange(0, str.length)
                    
                    while (currentRange.location != NSNotFound) {
                        var title = ""
                        if (!isContent) {
                            title = "{\((itemData[UInt(i)] as TemplateItem).item_title)}"
                        } else {
                            title = "\((itemData[UInt(i)] as TemplateItem).item_content)"
                        }
                        currentRange = str.rangeOfString(title, options: NSStringCompareOptions.LiteralSearch, range: currentRange)
                        if(currentRange.location != NSNotFound) {
                            attrText.addAttribute(NSForegroundColorAttributeName, value: UIColor.MainColor(), range: str.rangeOfString(title, options: NSStringCompareOptions.LiteralSearch, range: currentRange))
                            textField.attributedText = attrText
                            var from: Int = currentRange.location + (title as NSString).length
                            var end: Int = str.length - from
                            currentRange = NSMakeRange(from, end)
                        }
                    }
                }
            } else {
                return
            }
        }
    }
}


// 画面描画関係
struct ViewCommon {

    // 確認(OK)ダイアログ表示
    static func confirmDiarog(view: UIViewController, msg: String, okAction: UIAlertAction?) {
        
        // アラートコントローラー作成
        let alertController = UIAlertController(title: "確認", message: "\(msg)", preferredStyle: .Alert)
        
        // OKボタン作成
        if let act = okAction {
            alertController.addAction(act)
        } else {
            let act = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
                action -> Void in
                return
            }
            alertController.addAction(act)
        }
        
        // アラート表示
        view.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // 確認(OK/CANCEL)ダイアログ表示
    static func confirmDiarog(view: UIViewController, msg: String, okAction: UIAlertAction, cancelAction: UIAlertAction?) {
        
        // アラートコントローラー作成
        let alertController = UIAlertController(title: "確認", message: "\(msg)", preferredStyle: .Alert)
        
        // CANCELボタン作成
        if let act = cancelAction {
            alertController.addAction(act)
        } else {
            let act = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default){
                action -> Void in
                return
            }
            alertController.addAction(act)
        }
        
        // OKボタン作成
        alertController.addAction(okAction)
        
        // アラート表示
        view.presentViewController(alertController, animated: true, completion: nil)
    }
}

// メーラー関係
struct MaillerCommon {
    
    // メール本文作成処理
    static func createSentence(key: String, str: String) ->String {
        
        // 文章作成用変数
        var sentence: String = str
        
        // テンプレートITEMデータを全取得し本文作成
        if let result = TemplateItem.selectAllTemplateItem(key)?.sortedResultsUsingProperty("disp_no", ascending: true) {
            let cnt = result.count
            for (var i = 0; i < Int(cnt); i++) {
                let object = result.objectAtIndex(UInt(i)) as TemplateItem
                sentence = sentence.stringByReplacingOccurrencesOfString("{\(object.item_title)}", withString: "\(object.item_content)", options: nil, range: nil)
            }
        }
        
        return sentence
    }
}