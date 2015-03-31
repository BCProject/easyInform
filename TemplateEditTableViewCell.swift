//
//  TemplateEditTableViewCell.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/21.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import UIKit

class TemplateEditTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layoutMargins = UIEdgeInsetsZero
        self.separatorInset = UIEdgeInsetsZero
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
