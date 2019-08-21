//
//  NoteCoordinator.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 21/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import UIKit

/// Coordinators used in adding/modifying note text

struct NoteCoordinator: Coordinator {
    var parentViewController: UIViewController?
    var completionHandler: (NoteResult) -> Void
    var defaultContent: String?
    init(parentViewController: UIViewController, defaultContent: String?, completionHandler: @escaping (NoteResult) -> Void) {
        self.parentViewController = parentViewController
        self.completionHandler = completionHandler
        self.defaultContent = defaultContent
    }
    func start() {
        let viewController = AlertHelper.singleNoteViewController(defaultContent: defaultContent, completionHandler: completionHandler)
        parentViewController?.present(viewController, animated: true, completion: nil)
    }
}
