//
//  LocationManager.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 21/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import Foundation
import CoreLocation

// Tracks the user's current location, hiding CoreLocation's complexities.

class LocationManager: NSObject {
    let locationManager = CLLocationManager()

    // A default location manager, shared so it can be used across the app to observe the current location as necessary.
    static let sharedLocationManager = LocationManager()

    var currentLocation: CLLocationCoordinate2D?

    /// Function needs to be called to start tracking the user
    func startCoreLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    /// This function determines whether the user has denied access to tracking.
    var coreLocationAccessWasDenied = {
        return CLLocationManager.authorizationStatus() == .denied
    }

}

// MARK: CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
}
