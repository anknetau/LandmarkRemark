//
//  Theme.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 19/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import UIKit

// Theme information for the project.

struct Theme {

    // Colours to be used to tint the map pin.

    static let userLocationColour = UIColor.blue
    static let ownRemarkColour = UIColor.red
    static let otherRemarkColours: [UIColor] = [
        UIColor.green,
        UIColor.yellow,
        UIColor.orange,
        UIColor.purple,
        UIColor.brown,
        UIColor.lightGray
    ]
}
