//
//  MapCoordinator.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 21/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import UIKit

struct MapCoordinator: Coordinator {
    var parentViewController: UIViewController
    var username: String
    init(parentViewController: UIViewController, username: String) {
        self.parentViewController = parentViewController
        self.username = username
    }
    func start() {
        let mapViewController = MapViewController()
        mapViewController.viewModel = MapViewModel(username: username)
        parentViewController.present(mapViewController, animated: true, completion: nil)
    }
}
