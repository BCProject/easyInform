//
//  CustomButton.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/22.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.backgroundColor = UIColor.MainColor()
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10.0
    }

}
