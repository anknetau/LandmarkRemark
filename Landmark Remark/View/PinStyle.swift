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
    
    // Given a PinStyle, what should we use for its colour?
    var colour: UIColor {
        switch (self) {
        case .userLocation:
            return Theme.userLocationColour
        case .ownRemark:
            return Theme.ownRemarkColour
        case .otherRemark:
            return Theme.otherRemarkColour
        }
    }
    
    // Which image to use, or nil if default
    var image: UIImage? {
        switch (self) {
        case .userLocation:
            return Theme.locationImage
        case .ownRemark:
            return Theme.pinOwnImage
        case .otherRemark:
            return Theme.pinOtherImage
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
        return isOwn ? .ownRemark : .otherRemark
    }
}
