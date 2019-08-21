//
//  MockService.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 18/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import Foundation

// A mock service that can be used to test and develop the app.

class MockService : Service {
    // For this mock service, we just keep a single list of items.
    var remarks: [Remark] = MockService.sampleRemarks()
    
    // Latest unique id
    var uniqueId = 1
    
    // Add a new remark
    func add(remark: Remark, completionHandler: @escaping (Result<Int, ServiceError>) -> Void) {
        // New unique ID is required
        uniqueId = uniqueId + 1

        // Update object's ID and store it
        let updatedRemark = Remark(remarkID: uniqueId, latitude: remark.latitude, longitude: remark.longitude, user: remark.user, note: remark.note)
        remarks.append(updatedRemark)
        
        // Call back with unique ID created
        completionHandler(.success(uniqueId))
    }
    
    // Delete a remark by ID
    func delete(uniqueId: Int, completionHandler: @escaping (Result<Int, ServiceError>) -> Void) {
        // Remove matching remarks from array
        remarks.removeAll { $0.remarkID == uniqueId }
        completionHandler(.success(1))
    }
    
    // List all existing remarks
    func listAll(completionHandler: @escaping (Result<[Remark], ServiceError>) -> Void) {
        // Just return the whole array
        completionHandler(.success(remarks))
    }
    
    // Search by text
    func search(string: String, completionHandler: @escaping (Result<[Remark], ServiceError>) -> Void) {
        // Simple case insensitive search within the array
        let rows = remarks.filter { $0.user.lowercased().contains(string.lowercased()) || $0.note.lowercased().contains(string.lowercased()) }
        completionHandler(.success(rows))
    }
    
    // Update an existing remark
    func update(remark: Remark, completionHandler: @escaping (Result<Int, ServiceError>) -> Void) {
        // Exchange existing object in ID with new one
        remarks = remarks.map { $0.remarkID == remark.remarkID ? $0 : remark }
        completionHandler(.success(1))
    }

    // Just a set of sample remarks, from the mock data.
    private static func sampleRemarks() -> [Remark] {
        var uniqueId = 0
        return MockData.locations.map {
            location in
            uniqueId = uniqueId + 1
            return Remark(remarkID: uniqueId, latitude: location.0, longitude: location.1, user: "user", note: "this is a note for location \(uniqueId)")
        }
    }
    
}
