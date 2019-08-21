//
//  SetupViewModel.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 21/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import Foundation
import UIKit // necessary because of UIDevice access

/// ViewModel for the setup screen

struct SetupViewModel {
    
    // Username to display. Defaults to the name of the device
    
    var username: String? = UIDevice.current.name
    
    // Is this a valid username?
    func validUsername(username: String?) -> Bool {
        guard let username = username, !username.isEmpty else {
            return false
        }
        return true
    }
}
