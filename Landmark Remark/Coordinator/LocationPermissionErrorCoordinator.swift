//
//  LocationPermissionErrorCoordinator.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 22/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import UIKit

/// Coordinator used to display an error message to the user when they didn't allow location access

struct LocationPermissionErrorCoordinator: Coordinator {
    var parentViewController: UIViewController?
    var completionHandler: (PermissionResult) -> Void
    var message: String
    init(parentViewController: UIViewController, message: String, completionHandler: @escaping (PermissionResult) -> Void) {
        self.parentViewController = parentViewController
        self.completionHandler = completionHandler
        self.message = message
    }
    func start() {
        let viewController = AlertHelper.permissionErrorViewController(message: message, completionHandler: completionHandler)
        parentViewController?.present(viewController, animated: true, completion: nil)
    }
}
