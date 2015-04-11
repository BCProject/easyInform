//
//  CreateData.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/09.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import Foundation
import Realm

class CreateData {
    init(){
        
        // オブジェクト保存
        // テンプレート1 ヘッド作成
        let template1Head = TemplateHead()
        template1Head.template_name = "テンプレート1"
        template1Head.mail_address = "mailFrom1@brainchild.co.jp;"
        template1Head.mail_address_to = "\"遅刻太郎\"<mailTo1@brainchild.co.jp>;"
        template1Head.mail_address_cc = "\"遅刻次郎\"<mailCc1@brainchild.co.jp>;"
        template1Head.mail_title = "【勤怠連絡】遅刻 {取得日} 佐藤"
        template1Head.mail_body = "宛先各位\n\nお疲れ様です。佐藤です。\n{理由}のため、遅刻します。\n{出社時刻}頃出社予定です。\n\n以上です。"
        template1Head.disp_no = 0
        
        // テンプレート1 アイテム1作成
        let template1Item1 = TemplateItem()
        template1Item1.item_title = "取得日"
        template1Item1.item_type = ItemType.DATE
        template1Item1.item_format = ItemFormat.MD_SLA
        template1Item1.item_image = ItemImage.DATE
        template1Item1.item_content = "3/13"
        template1Item1.disp_no = 0
        template1Item1.template_head = template1Head
        template1Head.templateItem.addObject(template1Item1)
        if (TemplateItem.insertAllTemplateItem(template1Item1) == false) {
            return
        }
        
        // テンプレート1 アイテム2作成
        let template1Item2 = TemplateItem()
        template1Item2.item_title = "出社時刻"
        template1Item2.item_type = ItemType.TIME
        template1Item2.item_format = ItemFormat.HMM_COL
        template1Item2.item_image = ItemImage.TIME
        template1Item2.item_content = "10:00"
        template1Item2.disp_no = 1
        template1Item2.template_head = template1Head
        template1Head.templateItem.addObject(template1Item2)
        if (TemplateItem.insertAllTemplateItem(template1Item2) == false) {
            return
        }
        
        // テンプレート1 アイテム3作成
        let template1Item3 = TemplateItem()
        template1Item3.item_title = "理由"
        template1Item3.item_type = ItemType.TEXT
        template1Item3.item_format = ItemFormat.NONE
        template1Item3.item_image = ItemImage.TEXT
        template1Item3.item_content = "電車遅延"
        template1Item3.disp_no = 2
        template1Item3.template_head = template1Head
        template1Head.templateItem.addObject(template1Item3)
        if (TemplateItem.insertAllTemplateItem(template1Item3) == false) {
            return
        }
        
        // テンプレート1 アイテム4作成
        let template1Item4 = TemplateItem()
        template1Item4.item_title = "備考"
        template1Item4.item_type = ItemType.TEXT
        template1Item4.item_format = ItemFormat.NONE
        template1Item4.item_image = ItemImage.COMENT
        template1Item4.item_content = "現場責任者報告済み"
        template1Item4.disp_no = 3
        template1Item4.template_head = template1Head
        template1Head.templateItem.addObject(template1Item4)
        if (TemplateItem.insertAllTemplateItem(template1Item4) == false) {
            return
        }
        
        // テンプレート2 ヘッド作成
        let template2Head = TemplateHead()
        template2Head.template_name = "テンプレート2"
        template2Head.mail_address = "mailFrom2@brainchild.co.jp;"
        template2Head.mail_address_to = "\"早退太郎\"<mailTo2@brainchild.co.jp>;"
        template2Head.mail_address_cc = "\"早退次郎\"<mailCc2@brainchild.co.jp>;"
        template2Head.mail_title = "【勤怠連絡】早退 {取得日} 佐藤"
        template2Head.mail_body = "宛先各位\n\nお疲れ様です。佐藤です。\n{理由}のため、早退します。\n{退社時刻}頃退社しました。\n\n以上です。"
        template2Head.disp_no = 1
        
        // テンプレート2 アイテム1作成
        let template2Item1 = TemplateItem()
        template2Item1.item_title = "取得日"
        template2Item1.item_type = ItemType.DATE
        template2Item1.item_format = ItemFormat.MD_SLA
        template2Item1.item_image = ItemImage.DATE
        template2Item1.item_content = "3/12"
        template2Item1.disp_no = 0
        template2Item1.template_head = template2Head
        template2Head.templateItem.addObject(template2Item1)
        if (TemplateItem.insertAllTemplateItem(template2Item1) == false) {
            return
        }
        
        // テンプレート2 アイテム2作成
        let template2Item2 = TemplateItem()
        template2Item2.item_title = "退社時刻"
        template2Item2.item_type = ItemType.TIME
        template2Item2.item_format = ItemFormat.HMM_COL
        template2Item2.item_image = ItemImage.TIME
        template2Item2.item_content = "15:00"
        template2Item2.disp_no = 1
        template2Item2.template_head = template2Head
        template2Head.templateItem.addObject(template2Item2)
        if (TemplateItem.insertAllTemplateItem(template2Item2) == false) {
            return
        }
        
        // テンプレート2 アイテム3作成
        let template2Item3 = TemplateItem()
        template2Item3.item_title = "理由"
        template2Item3.item_type = ItemType.TEXT
        template2Item3.item_format = ItemFormat.NONE
        template2Item3.item_image = ItemImage.COMENT
        template2Item3.item_content = "体調不良"
        template2Item3.disp_no = 2
        template2Item3.template_head = template2Head
        template2Head.templateItem.addObject(template2Item3)
        if (TemplateItem.insertAllTemplateItem(template2Item3) == false) {
            return
        }
    }
}
