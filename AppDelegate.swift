//
//  AppDelegate.swift
//  easyInform
//
//  Created by 竿尾良平 on 2015/03/09.
//  Copyright (c) 2015年 Brainchild Inc. All rights reserved.
//

import UIKit
import Realm

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var template: String?
    var statusBarHeight:CGFloat?
    var statusBarWidth:CGFloat?
    var navBarHeight :CGFloat?
    var tabBarHeight :CGFloat?
    var availableViewHeight :CGFloat?
    var availableViewWidth :CGFloat?
    var editTemplateName: String?
    var editItemNo: NSInteger?
    var editItemTitle: String?
    var sendHistoryNo: NSInteger?
    var sendHistorySendD: NSDate?
    var hideBanner: Bool = false

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Realmファイルパス変更
        let filePath: NSArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.UserDomainMask,true)
        let realmFile: NSString = (filePath.lastObject as NSString) + "/easyInform.realm"
        RLMRealm.setDefaultRealmPath(realmFile)

        // データ初期化
        if (TemplateHead.allObjects().count == 0){
            CreateData.init()
        }

        // ナビゲーションアイコン 背景色変更
        UINavigationBar.appearance().tintColor = UIColor.MainColor()
        
        // ナビゲーションタイトル 文字色変更
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.MainColor()]
        
        // タブアイコン 選択時の色変更
        UITabBar.appearance().tintColor = UIColor.MainColor()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

