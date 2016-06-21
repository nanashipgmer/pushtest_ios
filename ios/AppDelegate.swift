//
//  AppDelegate.swift
//  ios
//
//  Created by 柳沼匠 on 2016/06/17.
//  Copyright © 2016年 柳沼匠. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var viewController: ViewController?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
        FIRApp.configure()
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.Unknown)
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
    
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        // 受信したメッセージをポップアップで表示
        if application.applicationState == .Active {
            if let aps = userInfo["aps"] as? NSDictionary {
                if let alert = aps["alert"] as? String {
                    
                    // ファイル名
                    let now = NSDate()
                    let formatter = NSDateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd_HH:mm:ss"
                    let fileName = formatter.stringFromDate(now) + "-message.txt"
                    let text = alert // 保存する内容
                    
                    // ファイル書き込み
                    if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
                        
                        let pathFileName = dir.stringByAppendingPathComponent(fileName)
//                        do {
//                            try text.writeToFile(pathFileName, atomically: false, encoding: NSUTF8StringEncoding)
//                        } catch {
//                            // エラー処理
//                        }
                        
                        let output = NSOutputStream(toFileAtPath: pathFileName, append: true);
                        output?.open()
                        let cstring = text.cStringUsingEncoding(NSUTF8StringEncoding)
                        let bytes = UnsafePointer<UInt8>(cstring!)
                        let size = text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
                        output?.write(bytes, maxLength: size)
                        output?.close()
                    }
                    
                    // ファイル読み込み
                    if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
                        
                        let pathFileName = dir.stringByAppendingPathComponent(fileName)
                        do {
                            let text = try NSString(contentsOfFile: pathFileName, encoding: NSUTF8StringEncoding)
                            print(text)
                        } catch {
                            // エラー処理
                        }
                    }
                    
                    if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
                        
                        do {
                            let manager = NSFileManager.defaultManager()
                            let list = try manager.contentsOfDirectoryAtPath(dir as String)
                            print("■ファイル名")
                            for path in list {
                                print(path as NSString)
                            }
                        } catch {
                            // エラー処理
                        }
                    }
                    
                    let alert = UIAlertController(title: alert, message: nil, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
                    
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.viewController?.reloadTableView()                }
            }
        }
    }
}

