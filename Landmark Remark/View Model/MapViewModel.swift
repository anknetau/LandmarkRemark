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
    /// Called when filtered results are refreshed
    func filteredResultsAvailable()
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
    /// A list of the remarks filtered down by search
    var filteredRemarks: [Remark] = []
    /// A simple way to stop search results from overriding each other, in th absence of Rx
    private var searchIdentifier = 0
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
    
    // Performs search, then filters location down to the searched term
    // Pass in nil to clear search
    func search(string: String?) {
        filteredRemarks = []
        guard let string = string else {
            refresh()
            return
        }
        
        searchIdentifier = searchIdentifier + 1
        search(searchIdentifier: searchIdentifier, string: string)
    }
    
    // Perform the async search itself
    private func search(searchIdentifier: Int, string: String) {
        service.search(string: string, completionHandler: { [weak self] result in
            DispatchQueue.main.async {
                // if the search is no longer current, bail
                if self?.searchIdentifier != searchIdentifier {
                    return
                }
                switch (result) {
                case .failure(_):
                    // Note: this should be debounced to stop the user from receiving too many alerts
                    self?.delegate?.didEncounterError(description: "Error while searching")
                case .success(let remarks):
                    self?.filteredRemarks = remarks
                    self?.delegate?.filteredResultsAvailable()
                }
            }
        })
        
    }
}

/// Delegate call to track when the user has moved.
extension MapViewModel: LocationManagerDelegate {
    func didUpdateLocation() {
        delegate?.userDidChangeLocation()
    }
}
