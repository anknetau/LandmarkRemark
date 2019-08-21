//
//  MapViewModel.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 18/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import Foundation

protocol MapViewModelDelegate : AnyObject {
    func didChangeRemarks()
    func didEncounterError(description: String)
}

/// The View Model to provide data to the MapViewController.
class MapViewModel {
    /// Initialisation requires the username
    init(username: String) {
        self.username = username
    }
    /// The current username
    var username: String
    /// A list of the remarks to display
    var currentRemarks: [Remark] = []
    /// The service that will be used to perform remote API updates.
    var service = APIService()

    weak var delegate: MapViewModelDelegate?
    
    /// Called when the VC needs refreshed data from the server
    func refresh() {
        service.listAll { [weak self] result in
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
