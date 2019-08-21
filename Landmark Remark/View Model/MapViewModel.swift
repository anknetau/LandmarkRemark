//
//  MapViewModel.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 18/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import Foundation
import CoreLocation

protocol MapViewModelDelegate : AnyObject {
    /// Called when new remarks are ready to be displayed
    func didChangeRemarks()
    /// Called when an error happens during API calls
    func didEncounterError(description: String)
    /// Called when the user's location changes
    func userDidChangeLocation()
    /// Called as the refresh API call start
    func didStartRefreshing()
    /// Called as the refresh API call finish
    func didEndRefreshing()
}

/// The View Model to provide data to the MapViewController.
class MapViewModel {
    /// Initialisation requires the username
    init(username: String, service: Service = APIService(), locationManager: LocationManager = PhysicalLocationManager()) {
        self.username = username
        self.service = service
        self.locationManager = locationManager
        locationManager.delegate = self
    }
    // Location Manager to track the user's location and movements
    var locationManager: LocationManager
    /// The current username
    var username: String
    /// A list of the remarks to display
    var currentRemarks: [Remark] = []
    /// The service that will be used to perform remote API updates.
    var service: Service
    /// Return the user's current location or nil if not known.
    var userLocation: CLLocationCoordinate2D? {
        return locationManager.currentLocation
    }

    weak var delegate: MapViewModelDelegate?
    
    /// Called when the VC needs refreshed data from the server
    func refresh() {
        delegate?.didStartRefreshing()
        service.listAll { [weak self] result in
            // Ensure we are in the UI thread
            DispatchQueue.main.async {
                // Signal finishing load
                self?.delegate?.didEndRefreshing()
                // Send through results
                switch (result) {
                case .failure(_):
                    self?.delegate?.didEncounterError(description: "Could not retrieve data")
                case .success(let remarks):
                    self?.currentRemarks = remarks
                    self?.delegate?.didChangeRemarks()
                }
            }
        }
    }
    
    // Initialise tracking system, ask user if they want to be tracked (if necessary).
    func startTrackingUser() {
        locationManager.startTrackingUser()
    }
    
    // Adds a new remark. Will trigger a refresh.
    func add(remark: Remark) {
        service.add(remark: remark) { [weak self] result in
            // Ensure we are in the UI thread
            DispatchQueue.main.async {
                switch (result) {
                case .failure(_):
                    self?.delegate?.didEncounterError(description: "Could not add note")
                case .success(_):
                    self?.refresh()
                }
            }
        }
    }
    
    // Updates a remark. Will trigger a refresh.
    func update(remark: Remark) {
        service.update(remark: remark) { [weak self] result in
            // Ensure we are in the UI thread
            DispatchQueue.main.async {
                switch (result) {
                case .failure(_):
                    self?.delegate?.didEncounterError(description: "Could not edit note")
                case .success(_):
                    self?.refresh()
                }
            }
        }
    }
    
    // Deletes a remark. Will trigger a refresh.
    func delete(uniqueId: Int) {
        service.delete(uniqueId: uniqueId) { [weak self] result in
            // Ensure we are in the UI thread
            DispatchQueue.main.async {
                switch (result) {
                case .failure(_):
                    self?.delegate?.didEncounterError(description: "Could not delete note")
                case .success(_):
                    self?.refresh()
                }
            }
        }
        
    }
}

/// Delegate call to track when the user has moved.
extension MapViewModel: LocationManagerDelegate {
    func didUpdateLocation() {
        delegate?.userDidChangeLocation()
    }
}
