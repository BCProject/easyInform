//
//  MailBodyTextView.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/22.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import UIKit

class MailBodyTextView: UITextView {
    
    // 入力文字数
    var _textLength: Int = 0

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func resize(height: CGFloat, width: CGFloat) {
        
        // 本文(TextView)リサイズ
        var frame: CGRect = self.frame
        frame.size.height = height
        frame.size.width = width
        self.frame = frame
    }

}
