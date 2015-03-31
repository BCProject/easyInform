//
//  ItemSelectLabel.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/22.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import UIKit

class ItemSelectLabel: UILabel {

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        self.font = UIFont.boldSystemFontOfSize(20)
        self.textColor = UIColor.MainColor()
        self.textAlignment = NSTextAlignment.Center
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10.0
    }

}
