//
//  LocationManager.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 21/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import Foundation
import CoreLocation // used for CLLocationCoordinate2D type

// Tracks the user's current location, allows stubbing.

protocol LocationManagerDelegate: AnyObject {
    /// Called when the location changes
    func didUpdateLocation()
}

protocol LocationManager: AnyObject {
    /// The delegate for this object
    var delegate: LocationManagerDelegate? { get set }
    /// Start tracking the user. Calling this will ask for permission in the UI.
    func startTrackingUser()
    /// Has tracking access been denied by the user?
    var locationAccessWasDenied: Bool { get }
    /// Current location of the user, or nil if unavailable.
    var currentLocation: CLLocationCoordinate2D? { get }
}
