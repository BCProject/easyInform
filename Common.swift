//
//  Common.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/18.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import Foundation

struct ItemType {
    static let TYPE: [String] = ["","テキスト","日付","日時","時刻"]
    static let TEXT: NSInteger = 1
    static let DATE: NSInteger = 2
    static let DATETIME: NSInteger = 3
    static let TIME: NSInteger = 4
}

struct ItemFormat {
    static let FORMAT: [String] = ["","YYYY/MM/DD","YYYY年MM月DD日","YYYY-MM-DD","YYYY/MM","YYYY年MM月","YYYY-MM","MM/DD","MM月DD日","MM-DD","M/D","M月D日","M-D","MM/DD HH:MM","MM月DD日 HH時MM分","M/D H:MM","M月D日 H時MM分","HH:MM","HH時MM分","H:M","H時M分","-"]
    static let DATE = 0...12
    static let DATETIME = 12...16
    static let TIME = 16...20
    static let TEXT = 20...21
    static let DATE_OFFSET: NSInteger = -1
    static let DATETIME_OFFSET: NSInteger = -13
    static let TIME_OFFSET: NSInteger = -17
    static let TEXT_OFFSET: NSInteger = -21
    static let YYYYMMDD_SLA: NSInteger = 1
    static let YYYYMMDD_JA: NSInteger = 2
    static let YYYYMMDD_HI: NSInteger = 3
    static let YYYYMM_SLA: NSInteger = 4
    static let YYYYMM_JA: NSInteger = 5
    static let YYYYMM_HI: NSInteger = 6
    static let MMDD_SLA: NSInteger = 7
    static let MMDD_JA: NSInteger = 8
    static let MMDD_HI: NSInteger = 9
    static let MD_SLA: NSInteger = 10
    static let MD_JA: NSInteger = 11
    static let MD_HI: NSInteger = 12
    static let MMDD_HHMM_COL: NSInteger = 13
    static let MMDD_HHMM_JA: NSInteger = 14
    static let MD_HMM_COL: NSInteger = 15
    static let MD_HMM_JA: NSInteger = 16
    static let HHMM_COL: NSInteger = 17
    static let HHMM_JA: NSInteger = 18
    static let HMM_COL: NSInteger = 19
    static let HMM_JA: NSInteger = 20
    static let NONE: NSInteger = 21
}

struct ItemImage {
    static let IMAGE: [String] = ["","date","time","text","number","money","coment","task"]
    static let DATE: NSInteger = 1
    static let TIME: NSInteger = 2
    static let TEXT: NSInteger = 3
    static let NUMBER: NSInteger = 4
    static let MONEY: NSInteger = 5
    static let COMENT: NSInteger = 6
    static let TASK: NSInteger = 7
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
    
    static func setTextFieldInputType(format: NSInteger) -> NSDateFormatter? {
        // 取得したテンプレートITEMのアイテム種類で処理分岐
        switch (format) {
        case ItemFormat.YYYYMMDD_SLA:
            let df = NSDateFormatter()
            df.locale     = NSLocale(localeIdentifier: "EN")
            df.dateFormat = "yyyy/MM/dd"
            return df
        case ItemFormat.YYYYMMDD_JA:
            let df = NSDateFormatter()
            df.locale     = NSLocale(localeIdentifier: "JA")
            df.dateFormat = "yyyy年MM月dd日"
            return df
        case ItemFormat.YYYYMMDD_HI:
            let df = NSDateFormatter()
            df.locale     = NSLocale(localeIdentifier: "EN")
            df.dateFormat = "yyyy-MM-dd"
            return df
        case ItemFormat.YYYYMM_SLA:
            let df = NSDateFormatter()
            df.locale     = NSLocale(localeIdentifier: "EN")
            df.dateFormat = "yyyy/MM"
            return df
        case ItemFormat.YYYYMM_JA:
            let df = NSDateFormatter()
            df.locale     = NSLocale(localeIdentifier: "JA")
            df.dateFormat = "yyyy年MM月"
            return df
        case ItemFormat.YYYYMM_HI:
            let df = NSDateFormatter()
            df.locale     = NSLocale(localeIdentifier: "EN")
            df.dateFormat = "yyyy-MM"
            return df
        case ItemFormat.MMDD_SLA:
            let df = NSDateFormatter()
            df.locale     = NSLocale(localeIdentifier: "EN")
            df.dateFormat = "MM/dd"
            return df
        case ItemFormat.MMDD_JA:
            let df = NSDateFormatter()
            df.locale     = NSLocale(localeIdentifier: "JA")
            df.dateFormat = "MM月dd日"
            return df
        case ItemFormat.MMDD_HI:
            let df = NSDateFormatter()
            df.locale     = NSLocale(localeIdentifier: "EN")
            df.dateFormat = "MM-dd"
            return df
        case ItemFormat.MD_SLA:
            let df = NSDateFormatter()
            df.locale     = NSLocale(localeIdentifier: "EN")
            df.dateFormat = "M/d"
            return df
        case ItemFormat.MD_JA:
            let df = NSDateFormatter()
            df.locale     = NSLocale(localeIdentifier: "JA")
            df.dateFormat = "M月d日"
            return df
        case ItemFormat.MD_HI:
            let df = NSDateFormatter()
            df.locale     = NSLocale(localeIdentifier: "EN")
            df.dateFormat = "M-d"
            return df
        case ItemFormat.MMDD_HHMM_COL:
            let df = NSDateFormatter()
            df.locale     = NSLocale(localeIdentifier: "EN")
            df.dateFormat = "MM/dd HH:mm"
            return df
        case ItemFormat.MMDD_HHMM_JA:
            let df = NSDateFormatter()
            df.locale     = NSLocale(localeIdentifier: "JA")
            df.dateFormat = "MM月dd日 HH時mm分"
            return df
        case ItemFormat.MD_HMM_COL:
            let df = NSDateFormatter()
            df.locale     = NSLocale(localeIdentifier: "EN")
            df.dateFormat = "M/d H:mm"
            return df
        case ItemFormat.MD_HMM_JA:
            let df = NSDateFormatter()
            df.locale     = NSLocale(localeIdentifier: "JA")
            df.dateFormat = "M月d日 H時mm分"
            return df
        case ItemFormat.HHMM_COL:
            let df = NSDateFormatter()
            df.locale     = NSLocale(localeIdentifier: "EN")
            df.dateFormat = "HH:mm"
            return df
        case ItemFormat.HHMM_JA:
            let df = NSDateFormatter()
            df.locale     = NSLocale(localeIdentifier: "JA")
            df.dateFormat = "HH時mm分"
            return df
        case ItemFormat.HMM_COL:
            let df = NSDateFormatter()
            df.locale     = NSLocale(localeIdentifier: "EN")
            df.dateFormat = "H:mm"
            return df
        case ItemFormat.HMM_JA:
            let df = NSDateFormatter()
            df.locale     = NSLocale(localeIdentifier: "JA")
            df.dateFormat = "H時mm分"
            return df
        case ItemFormat.NONE:
            return nil
        default:
            return nil
        }
    }
    
    // Date編集ダイアログ
    static func inputDateDialog(title:String, contents:String, df: NSDateFormatter, vc:UITableViewController) {
        
        if let vc = vc as? TemplateItemEditTableViewController {
        
            // アラートコントローラー作成
            let alertController: InputOneDateAlertController = InputOneDateAlertController(title: title, message: "\(title)を設定してください", preferredStyle: .Alert)
            alertController.setTextFieldOption(title, text1: contents, df: df)
            
            // キャンセルボタン作成
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .Cancel) { action -> Void in
                return
            }
            alertController.addAction(cancelAction)
            
            // 設定ボタン作成
            let setAction: UIAlertAction = UIAlertAction(title: "設定", style: .Default) { action -> Void in
                // 入力フォームから値を取得
                vc._content.text = alertController._textField1.text
            }
            alertController.addAction(setAction)
            
            // アラート表示
            vc.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // DateTime編集ダイアログ
    static func inputDateTimeDialog(title:String, contents:String, df: NSDateFormatter, vc:UITableViewController) {
        
        if let vc = vc as? TemplateItemEditTableViewController {
            
            // アラートコントローラー作成
            let alertController: InputOneDateTimeAlertController = InputOneDateTimeAlertController(title: title, message: "\(title)を設定してください", preferredStyle: .Alert)
            alertController.setTextFieldOption(title, text1: contents, df: df)
            
            // キャンセルボタン作成
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .Cancel) { action -> Void in
                return
            }
            alertController.addAction(cancelAction)
            
            // 設定ボタン作成
            let setAction: UIAlertAction = UIAlertAction(title: "設定", style: .Default) { action -> Void in
                // 入力フォームから値を取得
                vc._content.text = alertController._textField1.text
            }
            alertController.addAction(setAction)
            
            // アラート表示
            vc.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // Time編集ダイアログ
    static func inputTimeDialog(title:String, contents:String, df: NSDateFormatter, vc:UITableViewController) {
        
        if let vc = vc as? TemplateItemEditTableViewController {
            
            // アラートコントローラー作成
            let alertController: InputOneTimeAlertController = InputOneTimeAlertController(title: title, message: "\(title)を設定してください", preferredStyle: .Alert)
            alertController.setTextFieldOption(title, text1: contents, df: df)
            
            // キャンセルボタン作成
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .Cancel) { action -> Void in
                return
            }
            alertController.addAction(cancelAction)
            
            // 設定ボタン作成
            let setAction: UIAlertAction = UIAlertAction(title: "設定", style: .Default) { action -> Void in
                // 入力フォームから値を取得
                vc._content.text = alertController._textField1.text
            }
            alertController.addAction(setAction)
            
            // アラート表示
            vc.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // TEXT編集ダイアログ
    static func inputTextDialog(title:String, contents:String, vc:UITableViewController) {
        
        if let vc = vc as? TemplateItemEditTableViewController {
        
            // アラートコントローラー作成
            let alertController: InputOneTextAlertController = InputOneTextAlertController(title: title, message: "\(title)を設定してください", preferredStyle: .Alert)
            alertController.setTextFieldOption(title, text1: contents)
            
            // キャンセルボタン作成
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .Cancel) { action -> Void in
                return
            }
            alertController.addAction(cancelAction)
            
            // 設定ボタン作成
            let setAction: UIAlertAction = UIAlertAction(title: "設定", style: .Default) { action -> Void in
                
                // 入力フォームから値を取得
                vc._content.text = alertController._textField1.text
            }
            alertController.addAction(setAction)
            
            // アラート表示
            vc.presentViewController(alertController, animated: true, completion: nil)
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