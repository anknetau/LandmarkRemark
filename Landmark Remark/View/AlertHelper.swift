//
//  AlertHelper.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 21/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import UIKit

/// A way to keep alert logic together in one place.
/// As this VC is so simple, we are using simple callbacks instead of a delegate, and the given parameters rather than a VM.

struct AlertHelper {
    static func singleNoteViewController(defaultContent: String? = nil, completionHandler: @escaping (NoteResult) -> Void) -> UIViewController {
        // Create a simple UIAlertController to edit or add a note
        let alert = UIAlertController(title: "Add Remark", message: nil, preferredStyle: .alert)
        
        // Textfield to add or edit the note
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Note"
            textField.text = defaultContent
        })
        
        // Cancel action setup
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
            completionHandler(.cancelled)
        }))
        
        // OK action - merely passes the text entered.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            completionHandler(.finished(text: alert.textFields?[0].text))
        }))
        
        return alert
    }

    // Show a simple error
    static func errorViewController(message: String, completionHandler: (() -> Void)?) -> UIViewController {
        // Create a simple UIAlertController to show an error
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        // OK action to dismiss
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            completionHandler?()
        }))
        
        return alert
    }
    
    // If not allowed to get location, show an error and ask the user for permission.
    static func permissionErrorViewController(message: String, completionHandler: @escaping (PermissionResult) -> Void) -> UIViewController {
        // Create a simple UIAlertController to show an error
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Change settings", style: .default, handler: { action in
            completionHandler(.changeSettings)
        }))

        // OK action to dismiss
        alert.addAction(UIAlertAction(title: "Ignore", style: .destructive, handler: { action in
            completionHandler(.ignore)
        }))
        
        return alert
    }

}

/// Models for callbacks

enum NoteResult {
    case finished(text: String?)
    case cancelled
}

enum PermissionResult {
    case changeSettings
    case ignore
}
