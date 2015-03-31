//
//  TemplateHead.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/09.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import Foundation
import Realm

class TemplateHead : RLMObject {
    dynamic var template_name: String = ""
    dynamic var mail_address: String = ""
    dynamic var mail_address_to: String = ""
    dynamic var mail_address_cc: String = ""
    dynamic var mail_address_bcc: String = ""
    dynamic var mail_title: String = ""
    dynamic var mail_body: String = ""
    dynamic var disp_no: NSInteger = 0
    
    dynamic var templateItem:RLMArray = RLMArray(objectClassName: TemplateItem.className())
    
    // レコード取得処理
    class func selectTemplateHead(key: String) -> TemplateHead? {
        let result = TemplateHead()
        if let object = self.objectsWithPredicate(NSPredicate(format: "template_name = %@", key)).firstObject() as? TemplateHead {
            result.template_name = object.template_name
            result.mail_address_to = object.mail_address_to
            result.mail_address_cc = object.mail_address_cc
            result.mail_address_bcc = object.mail_address_bcc
            result.mail_address = object.mail_address
            result.mail_title = object.mail_title
            result.mail_body = object.mail_body
            result.disp_no = object.disp_no
            result.templateItem = result.templateItem
        }
        return result
    }
    
    // レコード作成処理
    class func insertTemplateHead(object: TemplateHead) -> Bool? {
        var result: Bool = true
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
    
    // レコード更新処理
    class func updateTemplateHead(object: TemplateHead) -> Bool? {
        var result: Bool = true
        
        RLMRealm.defaultRealm().beginWriteTransaction()
        SwiftTryCatch.try({
            var templateHead = TemplateHead(forPrimaryKey: object.template_name)
            if (templateHead.mail_address_to != object.mail_address_to) {
                templateHead.mail_address_to = object.mail_address_to
            }
            if (templateHead.mail_address_cc != object.mail_address_cc) {
                templateHead.mail_address_cc = object.mail_address_cc
            }
            if (templateHead.mail_address_bcc != object.mail_address_bcc) {
                templateHead.mail_address_bcc = object.mail_address_bcc
            }
            if (templateHead.mail_address != object.mail_address) {
                templateHead.mail_address = object.mail_address
            }
            if (templateHead.mail_title != object.mail_title) {
                templateHead.mail_title = object.mail_title
            }
            if (templateHead.mail_body != object.mail_body) {
                templateHead.mail_body = object.mail_body
            }
            RLMRealm.defaultRealm().commitWriteTransaction()
            }, catch: { (error) in
                RLMRealm.defaultRealm().cancelWriteTransaction()
                println("\(error.description)")
                result = false
            }, finally: {
        })
        return result
    }
    
    // レコード削除処理
    class func deleteTemplateHead(key: String) -> Bool? {
        var result: Bool = true
        RLMRealm.defaultRealm().beginWriteTransaction()
        SwiftTryCatch.try({
            let object = TemplateHead.objectsWhere("template_name = '\(key)'")
            RLMRealm.defaultRealm().deleteObject(object.firstObject() as RLMObject)
            RLMRealm.defaultRealm().commitWriteTransaction()
            }, catch: { (error) in
                RLMRealm.defaultRealm().cancelWriteTransaction()
                println("\(error.description)")
                result = false
            }, finally: {
        })
        return result
    }
    
    // disp_no取得
    class func getLastDispNo() -> NSInteger? {
        if let no = TemplateHead.allObjects() {
            return NSInteger(no.count + 1)
        }
        return 0
    }
    
    override class func primaryKey() -> String! {
        return "template_name"
    }
}