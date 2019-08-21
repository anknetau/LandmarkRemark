//
//  ErrorCoordinator.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 22/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import UIKit

/// Coordinator used to display an error message to the user

struct ErrorCoordinator: Coordinator {
    var parentViewController: UIViewController?
    var completionHandler: (() -> Void)?
    var message: String
    init(parentViewController: UIViewController, message: String, completionHandler: (() -> Void)?) {
        self.parentViewController = parentViewController
        self.completionHandler = completionHandler
        self.message = message
    }
    func start() {
        let viewController = AlertHelper.errorViewController(message: message, completionHandler: completionHandler)
        parentViewController?.present(viewController, animated: true, completion: nil)
    }
}
