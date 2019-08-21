//
//  Coordinator.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 18/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import Foundation

// Coordinators allow presentation and flow logic to be encapsulated outside of view controllers.
protocol Coordinator {
    // Called when the coordinator should perform the presentation/action.
    func start()
}
