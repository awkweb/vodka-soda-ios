//
//  AppDelegate.swift
//  vodka-soda
//
//  Created by Tom Meagher on 3/24/18.
//  Copyright © 2018 Tom Meagher. All rights reserved.
//

import UIKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Set up FB SDK
        FBSDKApplicationDelegate
            .sharedInstance()
            .application(application, didFinishLaunchingWithOptions: launchOptions)
        // initialize window
        self.window = UIWindow(frame: UIScreen.main.bounds)
        // guard against window being nil
        guard let window = self.window else { fatalError("no window") }
        // set window root view controller
        window.rootViewController = ViewController()
        // make window visible
        window.makeKeyAndVisible()
        return true
    }

    func application(_ application: UIApplication,
                     open url: URL,
                     sourceApplication: String?,
                     annotation: Any) -> Bool {
        // Set up FB SDK
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        return handled
    }

}
