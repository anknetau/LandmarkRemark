//
//  MockLocationManager.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 21/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import Foundation
import CoreLocation // used for CLLocationCoordinate2D type

// A mock location manager, used for testing.

class MockLocationManager: LocationManager {
    var delegate: LocationManagerDelegate?
    
    // An initial location which will be incremented via a timer.
    let initialLocation = (MockData.userLocation.0, MockData.userLocation.1)
    
    var simulatedLocation: (Double, Double)?
    
    var timer: Timer?
    
    func startTrackingUser() {
        // Every second, update the user's location
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    // Simulates a change in location
    @objc private func fireTimer() {
        // Setup or increment the coordinate slightly
        if let simulatedLocation = simulatedLocation {
            // Small delta increment to move the user
            let delta =  0.00001
            self.simulatedLocation = (simulatedLocation.0 + delta, simulatedLocation.1 + delta)
        } else {
            self.simulatedLocation = initialLocation
        }
        delegate?.didUpdateLocation()
    }
    
    var locationAccessWasDenied = false
    
    // Return the simulated location
    var currentLocation: CLLocationCoordinate2D? {
        guard let simulatedLocation = simulatedLocation else { return nil }
        return CLLocationCoordinate2D(latitude: simulatedLocation.0, longitude: simulatedLocation.1)
    }
}

