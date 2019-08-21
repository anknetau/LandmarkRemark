//
//  NoteCoordinator.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 21/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import UIKit

/// Coordinators used in adding/modifying/deleting notes

struct AddNoteCoordinator: Coordinator {
    var parentViewController: UIViewController?
    var completionHandler: (NoteResult) -> Void
    init(parentViewController: UIViewController, completionHandler: @escaping (NoteResult) -> Void) {
        self.parentViewController = parentViewController
        self.completionHandler = completionHandler
    }
    func start() {
        let viewController = AlertHelper.singleNoteViewController(completionHandler: completionHandler)
        parentViewController?.present(viewController, animated: true, completion: nil)
    }
}

struct EditNoteCoordinator: Coordinator {
    func start() {
        
    }
}
