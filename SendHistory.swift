//
//  SendHistory.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/25.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import Foundation
import Realm
class SendHistory : RLMObject {
    dynamic var history_no: NSInteger = 0
    dynamic var template_name: String = ""
    dynamic var mail_address: String = ""
    dynamic var mail_address_to: String = ""
    dynamic var mail_address_cc: String = ""
    dynamic var mail_address_bcc: String = ""
    dynamic var mail_title: String = ""
    dynamic var mail_body: String = ""
    dynamic var send_d: NSDate?
    
    // レコード挿入処理
    class func insertSendHistory(object: SendHistory) -> Bool? {
        var result: Bool = true
        let historyNo = SequenceManager.getSeq(self.className())
        if (SequenceManager.setSeq(self.className()) == false) {
            println("発番失敗")
            return false
        } else {
            object.history_no = historyNo!
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
    
    // レコード削除処理
    class func deleteSendHistory(key: NSInteger) -> Bool {
        var result: Bool = true
        RLMRealm.defaultRealm().beginWriteTransaction()
        SwiftTryCatch.try({
            let object = SendHistory(forPrimaryKey: key)
            RLMRealm.defaultRealm().deleteObject(object)
            RLMRealm.defaultRealm().commitWriteTransaction()
            }, catch: { (error) in
                RLMRealm.defaultRealm().cancelWriteTransaction()
                println("\(error.description)")
                result = false
            }, finally: {
        })
        return result
    }
    
    // 全レコード削除処理
    class func deleteAllSendHistory() -> Bool {
        var result: Bool = true
        RLMRealm.defaultRealm().beginWriteTransaction()
        SwiftTryCatch.try({
            let object = SendHistory.allObjects()
            for delObj in object {
                RLMRealm.defaultRealm().deleteObject(delObj)
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
    
    override class func primaryKey() -> String! {
        return "history_no"
    }
}
