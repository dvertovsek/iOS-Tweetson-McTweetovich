//
//  AppDelegate.swift
//  Tweetson
//
//  Created by MTLab on 16/01/16.
//  Copyright © 2016 dare. All rights reserved.
//

import UIKit
import ws
import SwiftyJSON
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var sideMenuViewController: TWTSideMenuViewController?
    var mainViewController: MainViewController?
    var menuViewController: MenuViewController?

    var httpReq: HTTPReq?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        self.menuViewController = MenuViewController()
        self.mainViewController = MainViewController()
        
        self.sideMenuViewController = TWTSideMenuViewController.init(menuViewController: self.menuViewController, mainViewController: UINavigationController(rootViewController: self.mainViewController!))
        
        self.sideMenuViewController?.shadowColor = UIColor.blackColor()
        self.sideMenuViewController?.edgeOffset = UIOffsetMake(18.0, 0.0)
        
        self.sideMenuViewController?.zoomScale = 0.5643
        
        self.window?.rootViewController = self.sideMenuViewController
        
        httpReq = HTTPReq(delegate: self)
        
        let headers = [
            "Authorization": "Basic "+ResourcesUtility.encodeKeyAndSecret(),
            "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
        ]
        let params = ["grant_type" : "client_credentials"]
        
        httpReq?.httprequest(Alamofire.Method.POST, url: "https://api.twitter.com/oauth2/token", headers: headers, parameters: params)
        
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

extension AppDelegate: WebServiceResultDelegate
{
    func getResult(result: AnyObject) {
        ResourcesUtility.bearerToken = String(JSON(result)["access_token"])
    }
}

