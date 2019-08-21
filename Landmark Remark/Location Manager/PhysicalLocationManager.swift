//
//  PhysicalLocationManager.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 21/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import Foundation
import CoreLocation

/// A location manager based on Core Location, hides CoreLocation's complexities.

class PhysicalLocationManager: NSObject, LocationManager {
    private let locationManager = CLLocationManager()
    
    weak var delegate: LocationManagerDelegate?
    
    // Current location as last tracked
    var currentLocation: CLLocationCoordinate2D?
    
    /// Function needs to be called to start tracking the user
    func startTrackingUser() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    /// This function determines whether the user has denied access to tracking.
    var locationAccessWasDenied: Bool {
        return CLLocationManager.authorizationStatus() == .denied
    }
}

// MARK: CLLocationManagerDelegate

extension PhysicalLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // If the location has changed, update the underlying object and let the delegate know.
        // We also only care about locations that are accurate to 20m or less.
        let closeLocations = locations.filter { $0.horizontalAccuracy < 20 }
        if let location = closeLocations.last {
            currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            delegate?.didUpdateLocation()
        }
    }
}
