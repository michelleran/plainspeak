//
//  AppDelegate.swift
//  fbchat
//
//  Created by Michelle Ran on 6/23/16.
//  Copyright © 2016 Michelle Ran LLC. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?)
        -> Bool {
            FIRApp.configure()
            Cloud.setup()
            return true
    }
    
}

