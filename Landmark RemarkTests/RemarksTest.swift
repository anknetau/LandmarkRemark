//
//  RemarksTest.swift
//  Landmark RemarkTests
//
//  Created by Andres Kievsky on 18/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import XCTest
@testable import Landmark_Remark

/// Tests that the user can see locations from the API

class RemarksTest: XCTestCase, MapViewModelDelegate {
    var mapViewModel: MapViewModel?
    
    let startLoadingExpectation = XCTestExpectation(description: "Start Loading was called")
    let finishLoadingExpectation = XCTestExpectation(description: "Finish Loading was called")
    let remarksExpectation = XCTestExpectation(description: "Remarks did load")
    
    override func setUp() {
        // Use a mock service and a mock location manager
        mapViewModel = MapViewModel(username: "user_1", service: MockService(), locationManager: MockLocationManager())
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
        XCTAssertEqual(mapViewModel.username, "user_1")
        
        // Test the delegate
        mapViewModel.delegate = self
        
        // Ask to refresh remarks
        mapViewModel.refresh()
        
        // User location should still be nil
        XCTAssertNil(mapViewModel.userLocation)
        
        wait(for: [startLoadingExpectation, finishLoadingExpectation, remarksExpectation], timeout: 10.0)
    }
    
    func didChangeRemarks() {
        XCTAssertEqual(mapViewModel?.currentRemarks.count, 6)
        remarksExpectation.fulfill()
    }
    
    func didEncounterError(description: String) {
        XCTFail("didEncounterError should not have been called")
    }
    
    func userDidChangeLocation() {
        XCTFail("userDidChangeLocation should not have been called")
    }
    
    func didStartRefreshing() {
        startLoadingExpectation.fulfill()
    }
    
    func didEndRefreshing() {
        finishLoadingExpectation.fulfill()
    }
}
