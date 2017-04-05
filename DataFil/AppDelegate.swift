//
//  AppDelegate.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 07/12/2016.
//  Copyright © 2016 Alex Gubbay. All rights reserved.
//

import UIKit
import WatchKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
 
        
        let dsm = DataSourceManager(sourceId: "device")
        dsm.initaliseDatasources()

       
        //TODO fix this.
        _ = FilterManager.sharedInstance
        _ = utilities.init()
        
        
        
        return true
    }
   
    func applicationWillResignActive(_ application: UIApplication) {
     
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
           }

    func applicationWillEnterForeground(_ application: UIApplication) {
       
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
       
    }


}

