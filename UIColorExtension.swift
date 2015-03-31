//
//  UIColorExtension.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/09.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import UIKit

extension UIColor {
    class func rgb(#r: Int, g: Int, b: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    class func MainColor() -> UIColor {
        return UIColor.rgb(r: 255, g: 45, b: 85, alpha: 1.0)
    }
    class func BackColor() -> UIColor {
        return UIColor.rgb(r: 246, g: 246, b: 246, alpha: 1.0)
    }
    class func DialogColor() -> UIColor {
        return UIColor.rgb(r: 23, g: 23, b: 23, alpha: 1.0)
    }
    class func BorderColor() -> UIColor {
        return UIColor.rgb(r: 188, g: 186, b: 193, alpha: 1.0)
    }
}