//
//  File.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 18/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import UIKit

/// The top-level coordinator for the whole app.
/// This allows the AppDelegate to know nothing about the initial view controller and simplifies
/// the logic in the app delegate, avoiding the classic "big/complex app delegate".
struct AppCoordinator : Coordinator {
    let window: UIWindow
    let rootViewController: UIViewController
    init(window: UIWindow) {
        self.window = window
        rootViewController = MapViewController()
    }

    /// This logic has been moved here from the app delegate as it's part of the initial setup of the window/VCs.
    func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
