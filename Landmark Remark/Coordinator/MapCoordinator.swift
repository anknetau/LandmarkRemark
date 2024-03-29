//
//  MapCoordinator.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 21/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import UIKit

/// Coordinator to display the map

struct MapCoordinator: Coordinator {
    var parentViewController: UIViewController
    /// Username to use in it
    var username: String
    init(parentViewController: UIViewController, username: String) {
        self.parentViewController = parentViewController
        self.username = username
    }
    func start() {
        let mapViewController = MapViewController()
        mapViewController.viewModel = MapViewModel(username: username, service: APIService(), locationManager: PhysicalLocationManager())
        // To see mock objects in action, use the following line instead of the above:
        // mapViewController.viewModel = MapViewModel(username: username, service: MockService(), locationManager: MockLocationManager())
        parentViewController.present(mapViewController, animated: true, completion: nil)
    }
}
