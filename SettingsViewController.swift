//
//  SettingsViewController.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/18.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import UIKit
import Realm

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickInitButton(sender: AnyObject) {
        NSFileManager.defaultManager().removeItemAtPath(RLMRealm.defaultRealmPath(), error: nil)
        
        // データ初期化
        if (TemplateHead.allObjects().count == 0){
            CreateData.init()
        }
    }

    

}
