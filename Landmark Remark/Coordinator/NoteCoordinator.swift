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
    init(parentViewController: UIViewController) {
        self.parentViewController = parentViewController
    }
    func start() {
        let viewController = AlertHelper.singleNoteViewController { result in
            // TODO
        }
        parentViewController?.present(viewController, animated: true, completion: nil)
    }
}

struct EditNoteCoordinator: Coordinator {
    func start() {
        
    }
}
