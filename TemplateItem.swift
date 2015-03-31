//
//  TemplateItem.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/11.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import Foundation
import Realm

class TemplateItem : RLMObject {
    dynamic var item_no: NSInteger = 0
    dynamic var item_title: String = ""
    dynamic var item_type: NSInteger = 0
    dynamic var item_image: String = ""
    dynamic var item_content: String = ""
    dynamic var disp_no: NSInteger = 0
    
    dynamic var template_head: TemplateHead = TemplateHead()
    
    // レコード取得全件処理
    class func selectAllTemplateItem(key: String) -> RLMArray? {
        let object = TemplateHead.objectsWithPredicate(NSPredicate(format: "template_name = %@", key))
        let result = object.firstObject() as TemplateHead
        return result.templateItem
    }
    
    // レコード取得処理 (disp_no)
    class func selectTemplateItem(key: String, disp_no: NSInteger) -> TemplateItem? {
        let result = TemplateItem()
        if let head = TemplateHead.objectsWithPredicate(NSPredicate(format: "template_name = %@", key)).firstObject() as? TemplateHead {
            if let items = self.objectsWithPredicate(NSPredicate(format: "template_head = %@", head)).sortedResultsUsingProperty("disp_no", ascending: true) {
                if let object = items[UInt(disp_no)] as? TemplateItem {
                    result.item_no = object.item_no
                    result.item_title = object.item_title
                    result.item_type = object.item_type
                    result.item_image = object.item_image
                    result.item_content = object.item_content
                    result.disp_no = object.disp_no
                    result.template_head = object.template_head
                }
            }
        }
        return result
    }
    
    // レコード挿入処理
    class func insertAllTemplateItem(object: TemplateItem) -> Bool? {
        var result: Bool = true
        let itemNo = SequenceManager.getSeq(self.className())
        if (SequenceManager.setSeq(self.className()) == false) {
            println("発番失敗")
            return false
        } else {
            object.item_no = itemNo!
        }
        RLMRealm.defaultRealm().beginWriteTransaction()
        SwiftTryCatch.try({
            RLMRealm.defaultRealm().addOrUpdateObject(object)
            RLMRealm.defaultRealm().commitWriteTransaction()
            }, catch: { (error) in
                RLMRealm.defaultRealm().cancelWriteTransaction()
                println("\(error.description)")
                result = false
            }, finally: {
        })
        return result
    }
    
    // レコード1件挿入処理
    class func insertTemplateItem(key: String, object: TemplateItem) -> Bool? {
        var result: Bool = true
        let itemNo = SequenceManager.getSeq(self.className())
        if (SequenceManager.setSeq(self.className()) == false) {
            println("発番失敗")
            return false
        } else {
            object.item_no = itemNo!
        }
        
        // 作成用にテンプレートITEMオブジェクトを定義し値をセット
        let templateItem: TemplateItem = TemplateItem()
        
        // テンプレートHEAD データ取得
        if let head = TemplateHead.objectsWithPredicate(NSPredicate(format: "template_name = %@", key)){
            
            let templateHead = TemplateHead()
            templateHead.template_name = head.firstObject().template_name
            templateHead.mail_address_to = head.firstObject().mail_address_to
            templateHead.mail_address_cc = head.firstObject().mail_address_cc
            templateHead.mail_address_bcc = head.firstObject().mail_address_bcc
            templateHead.mail_address = head.firstObject().mail_address
            templateHead.mail_title = head.firstObject().mail_title
            templateHead.mail_body = head.firstObject().mail_body
            templateHead.disp_no = head.firstObject().disp_no
            templateHead.templateItem = head.firstObject().templateItem
            
            templateItem.item_no = object.item_no
            if (object.item_title != templateItem.item_title) {
                templateItem.item_title = object.item_title
            }
            if (object.item_type != templateItem.item_type) {
                templateItem.item_type = object.item_type
            }
            if (object.item_image != templateItem.item_image) {
                templateItem.item_image = object.item_image
            }
            if (object.item_content != templateItem.item_content) {
                templateItem.item_content = object.item_content
            }
            if (object.disp_no != templateItem.disp_no) {
                templateItem.disp_no = object.disp_no
            }
            templateItem.template_head = templateHead
            templateHead.templateItem.addObject(templateItem)
        }

        RLMRealm.defaultRealm().beginWriteTransaction()
        SwiftTryCatch.try({
            RLMRealm.defaultRealm().addOrUpdateObject(templateItem)
            RLMRealm.defaultRealm().commitWriteTransaction()
            }, catch: { (error) in
                RLMRealm.defaultRealm().cancelWriteTransaction()
                println("\(error.description)")
                result = false
            }, finally: {
        })
        return result
    }
    
    // レコード更新処理
    class func updateTemplateItem(object: TemplateItem, key: String, disp_no: NSInteger) -> Bool? {
        var result: Bool = true
        if let out = self.selectTemplateItem(key, disp_no: disp_no) {
            RLMRealm.defaultRealm().beginWriteTransaction()
            var templateItem = TemplateItem(forPrimaryKey: out.item_no)
            if (!StringCommon.isBlank(object.item_title) && templateItem.item_title != object.item_title) {
                templateItem.item_title = object.item_title
            }
            if (!StringCommon.isBlank(object.item_image) && templateItem.item_image != object.item_image) {
                templateItem.item_image = object.item_image
            }
            if (object.item_type != 0 && templateItem.item_type != object.item_type) {
                templateItem.item_type = object.item_type
            }
            if (!StringCommon.isBlank(object.item_content) && templateItem.item_content != object.item_content) {
                templateItem.item_content = object.item_content
            }
            
            SwiftTryCatch.try({
                RLMRealm.defaultRealm().addOrUpdateObject(templateItem)
                RLMRealm.defaultRealm().commitWriteTransaction()
                }, catch: { (error) in
                    RLMRealm.defaultRealm().cancelWriteTransaction()
                    println("\(error.description)")
                    result = false
                }, finally: {
            })
        }
        return result
    }
    
    // レコード削除処理
    class func deleteTemplateItem(key: String, disp_no: NSInteger) -> Bool? {
        var result: Bool = true
        RLMRealm.defaultRealm().beginWriteTransaction()
        SwiftTryCatch.try({
                if let object = self.selectTemplateItem(key, disp_no: disp_no) {
                    let templateItem = TemplateItem.objectsWhere("item_no = \(object.item_no)")
                    RLMRealm.defaultRealm().deleteObject(templateItem.firstObject() as RLMObject)
                    RLMRealm.defaultRealm().commitWriteTransaction()
                }
            }, catch: { (error) in
                RLMRealm.defaultRealm().cancelWriteTransaction()
                println("\(error.description)")
                result = false
            }, finally: {
        })
        return result
    }
    
    // template_nameを指定してDisp_noの最大値を返す
    class func getLastDispNo(str:String) -> NSInteger? {
        if let results = TemplateHead.objectsWithPredicate(NSPredicate(format: "template_name = %@", str)) {
            let result = (results.firstObject() as TemplateHead).templateItem
            return NSInteger(result.count + 1)
        }
        return 0
    }
    
    override class func primaryKey() -> String! {
        return "item_no"
    }
}