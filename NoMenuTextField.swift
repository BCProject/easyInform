//
//  NoMenuTextField.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/04/10.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import UIKit

class NoMenuTextField: UITextField {

    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        UIMenuController.sharedMenuController().menuVisible = false
        return false
    }
}
