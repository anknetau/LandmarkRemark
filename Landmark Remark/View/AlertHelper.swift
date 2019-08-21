//
//  AlertHelper.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 21/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import UIKit

/// A way to keep alert logic together in one place.
/// As this VC is so simple, we are using a simple callback instead of a delegate, and the given parameters rather than a VM.

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
}

/// Model for the callback

enum NoteResult {
    case finished(text: String?)
    case cancelled
}
