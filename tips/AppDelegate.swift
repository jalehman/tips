//
//  AppDelegate.swift
//  tips
//
//  Created by Josh Lehman on 1/14/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        applyStyling()
        
        return true
    }
    
    func applyStyling() {
        let textColor: UIColor = UIColor(red: 0.843, green: 0.875, blue: 0.953, alpha: 1)
        
        // Navbar
        let medBlue = UIColor(red: 0.059, green: 0.2, blue: 0.525, alpha: 1)
        UINavigationBar.appearance().barTintColor = medBlue
        UISegmentedControl.appearance().tintColor = medBlue
        
        UITextField.appearance().tintColor = textColor
        
        // Nav buttons
        let textAttributes = [NSForegroundColorAttributeName: textColor]
        UISegmentedControl.appearance().setTitleTextAttributes(textAttributes, forState: UIControlState.Selected)
        UISegmentedControl.appearance().setTitleTextAttributes(textAttributes, forState: UIControlState.Normal)
        // Set this to make the back arrows white.
        UINavigationBar.appearance().tintColor = textColor
        UIBarButtonItem.appearance().setTitleTextAttributes(textAttributes, forState: UIControlState.Normal)
        UINavigationBar.appearance().titleTextAttributes = textAttributes
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

