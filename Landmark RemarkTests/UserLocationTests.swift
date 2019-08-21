//
//  Landmark_RemarkTests.swift
//  Landmark RemarkTests
//
//  Created by Andres Kievsky on 18/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import XCTest
@testable import Landmark_Remark

/// Tests that the user can see its location via the map view model

class UserLocationTests: XCTestCase, MapViewModelDelegate {
    var mapViewModel: MapViewModel?
    
    let userLocationExpectation = XCTestExpectation(description: "User did change location")
    
    override func setUp() {
        // Use a mock service and a mock location manager
        mapViewModel = MapViewModel(username: "user", service: MockService(), locationManager: MockLocationManager())
    }

    func testMapViewModel() {
        guard let mapViewModel = mapViewModel else {
            XCTFail("Test setup error")
            return
        }
        // Before starting to track or loading, locations should be empty
        XCTAssertEqual(mapViewModel.currentRemarks.count, 0)
        XCTAssertNil(mapViewModel.userLocation)
        
        // Should be as passed in
        XCTAssertEqual(mapViewModel.username, "user")
        
        // Test the delegate
        mapViewModel.delegate = self

        // Start the user tracking mock
        mapViewModel.startTrackingUser()
        
        // User location should still be nil
        XCTAssertNil(mapViewModel.userLocation)

        wait(for: [userLocationExpectation], timeout: 10.0)
    }

    func didChangeRemarks() {
        XCTFail("didChangeRemarks should not have been called")
    }
    
    func didEncounterError(description: String) {
        XCTFail("didEncounterError should not have been called")
    }
    
    func userDidChangeLocation() {
        // We wait until we receive a non-nil user location
        if let userLocation = mapViewModel?.userLocation {
            XCTAssertEqual(userLocation.latitude, MockData.userLocation.0)
            XCTAssertEqual(userLocation.longitude, MockData.userLocation.1)
            userLocationExpectation.fulfill()
        }
    }
    
    func didStartRefreshing() {
        XCTFail("didStartRefreshing should not have been called")
    }
    
    func didEndRefreshing() {
        XCTFail("didEndRefreshing should not have been called")
    }
}
