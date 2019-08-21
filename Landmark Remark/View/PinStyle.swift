//
//  PinStyle.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 19/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import UIKit

/// Models the pin style for different map pins, from within the view layer's perspective.
/// This showcases some simple protocol-oriented programming and the power of enums.

enum PinStyle {
    // Pin style used to display the user's location
    case userLocation
    // Pin style used to display a remark the user added
    case ownRemark
    // Pin style used to display a remark from another user
    case otherRemark

    // Keep track of the current colour being used
    private static var colourIndex = 0
    // Return the next available colour for a pin
    static var nextColour: UIColor {
        get {
            // Simply loop around the available colours
            colourIndex = colourIndex + 1
            if colourIndex == Theme.otherRemarkColours.count {
                colourIndex = 0
            }
            return Theme.otherRemarkColours[colourIndex]
        }
    }
    
    // Given a PinStyle, what should we use for its colour?
    var colour: UIColor {
        switch (self) {
        case .userLocation:
            return Theme.userLocationColour
        case .ownRemark:
            return Theme.ownRemarkColour
        case .otherRemark:
            return PinStyle.nextColour
        }
    }
}

/// Protocol to attach a pin style to a type.
protocol PinStyleContainer {
    var pinStyle: PinStyle { get }
}

/// What should the default styles be for different types?
extension UserLocationAnnotation {
    var pinStyle: PinStyle {
        return .userLocation
    }
}

extension RemarkAnnotation {
    var pinStyle: PinStyle {
        return .ownRemark
    }
}
