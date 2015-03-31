//
//  SequenceManager.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/14.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import Foundation
import Realm

class SequenceManager: RLMObject {
    var class_name: String = ""
    var seq: NSInteger = 0
    
    // class_nameを指定して結果を返す
    class func getSeq(str:String) -> NSInteger? {
        if let results = SequenceManager.objectsWithPredicate(NSPredicate(format: "class_name = %@", str)){
            if (results.count > 0) {
                return results.firstObject().seq + 1
            } else {
                return 0
            }
        }
        return 0
    }
    
    // 発番する
    class func setSeq(str: String) -> Bool? {
        var result: Bool = true
        let sequenceManager = SequenceManager()
        if let seq = getSeq(str) {
            sequenceManager.seq = seq
            sequenceManager.class_name = str
            
            // トランザクション開始
            RLMRealm.defaultRealm().beginWriteTransaction()
            SwiftTryCatch.try({
                
                // 発番レコード更新
                RLMRealm.defaultRealm().addOrUpdateObject(sequenceManager)
                
                // トランザクション終了
                RLMRealm.defaultRealm().commitWriteTransaction()
                }, catch: { (error) in
                    
                    // ロールバック
                    RLMRealm.defaultRealm().cancelWriteTransaction()
                    println("\(error.description)")
                    result = false
                }, finally: {
            })
            
        } else {
            result = false
        }
        return result
    }
    
    override class func primaryKey() -> String! {
        return "class_name"
    }
}