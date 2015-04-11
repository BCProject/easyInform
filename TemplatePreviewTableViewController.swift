//
//  TemplatePreviewTableViewController.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/04/11.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import UIKit

struct PreviewCell {
    static let defaultRowHeight: CGFloat = 40.0
    static let rowCount: Int = 5
    static let rowTitleLabel: [String] = ["宛先:","CC:","BCC:","件名:"]
}

class TemplatePreviewTableViewController: UITableViewController {

    // Appデリゲートオブジェクト
    let _ap:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = PreviewCell.defaultRowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.tableFooterView = UIView(frame: CGRectMake(0, 0, 0, 0))
        
        // ****************************************//
        // For Debug...
        if (!self._ap.hideBanner) {
            self.canDisplayBannerAds = true
        } else {
            self.canDisplayBannerAds = false
        }
        // ****************************************//
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // セクションタイトル
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let object = TemplateHead(forPrimaryKey: self._ap.editTemplateName) {
            return object.template_name
        } else {
            return nil
        }
    }
    
    // セクション数
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // テーブルセル行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PreviewCell.rowCount
    }
    
    // テーブルセル 内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // テンプレートHEAD情報取得
        if let object = TemplateHead(forPrimaryKey: self._ap.editTemplateName) {
            switch (indexPath.row) {
            case 0:
                // セルを定義
                var cell = tableView.dequeueReusableCellWithIdentifier("twoLabelCell") as TemplateEditTableViewCell
                var label = cell.viewWithTag(1) as UILabel
                label.text = PreviewCell.rowTitleLabel[indexPath.row]
                
                var addressTo = cell.viewWithTag(2) as UILabel
                if (!StringCommon.isBlank(StringCommon.lineFromSemicolon(object.mail_address_to))) {
                    addressTo.text = StringCommon.lineFromSemicolon(object.mail_address_to)
                } else {
                    addressTo.text = " "
                }
                
                return cell
            case 1:
                // セルを定義
                var cell = tableView.dequeueReusableCellWithIdentifier("twoLabelCell") as TemplateEditTableViewCell
                var label = cell.viewWithTag(1) as UILabel
                label.text = PreviewCell.rowTitleLabel[indexPath.row]
                
                var addressCc = cell.viewWithTag(2) as UILabel
                if (!StringCommon.isBlank(StringCommon.lineFromSemicolon(object.mail_address_cc))) {
                    addressCc.text = StringCommon.lineFromSemicolon(object.mail_address_cc)
                } else {
                    addressCc.text = " "
                }
                
                return cell
            case 2:
                // セルを定義
                var cell = tableView.dequeueReusableCellWithIdentifier("twoLabelCell") as TemplateEditTableViewCell
                var label = cell.viewWithTag(1) as UILabel
                label.text = PreviewCell.rowTitleLabel[indexPath.row]
                
                var addressBcc = cell.viewWithTag(2) as UILabel
                if (!StringCommon.isBlank(StringCommon.lineFromSemicolon(object.mail_address_bcc))) {
                    addressBcc.text = StringCommon.lineFromSemicolon(object.mail_address_bcc)
                } else {
                    addressBcc.text = " "
                }
                
                return cell
            case 3:
                // セルを定義
                var cell = tableView.dequeueReusableCellWithIdentifier("twoLabelCell") as TemplateEditTableViewCell
                var label = cell.viewWithTag(1) as UILabel
                label.text = PreviewCell.rowTitleLabel[indexPath.row]
                
                var subject = cell.viewWithTag(2) as UILabel
                if (!StringCommon.isBlank(MaillerCommon.createSentence(object.template_name, str: object.mail_title))) {
                    subject.text = MaillerCommon.createSentence(object.template_name, str: object.mail_title)
                } else {
                    subject.text = " "
                }
                
                return cell
            case 4:
                // セルを定義
                var cell = tableView.dequeueReusableCellWithIdentifier("oneLabelCell") as TemplateEditTableViewCell
                var body = cell.viewWithTag(1) as UILabel
                if (!StringCommon.isBlank(MaillerCommon.createSentence(object.template_name, str: object.mail_body))) {
                    body.text = MaillerCommon.createSentence(object.template_name, str: object.mail_body)
                } else {
                    body.text = " "
                }
                
                return cell
                
            default:
                // 空のセルを定義
                var cell = UITableViewCell()
                return cell
            }
        }
        
        // 空のセルを定義
        var cell = UITableViewCell()
        return cell
    }

}
