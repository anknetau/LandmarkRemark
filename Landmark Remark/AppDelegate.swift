//
//  AppDelegate.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 18/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    // Keep a reference to the root app coordinator to prevent it getting dealloc'ed
    private var appCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialise the first coordinator and thus the first view controller.
        let initialWindow = UIWindow(frame: UIScreen.main.bounds)
        window = initialWindow
        appCoordinator = AppCoordinator(window: initialWindow)
        appCoordinator?.start()
        return true
    }

}
