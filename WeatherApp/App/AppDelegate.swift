//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Nika Iobishvili on 9/17/20.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static var shared: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "SplashScreenWaiterViewController")
        
        self.window?.makeKeyAndVisible()
        return true
    }

}

