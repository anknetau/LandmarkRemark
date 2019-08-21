//
//  MapViewController.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 18/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var jumpToLocationButton: UIButton!
    @IBOutlet weak var expandButton: UIButton!
    
    let searchController = UISearchController(searchResultsController: nil)

    var viewModel: MapViewModel?
    
    // Ensure user has seen their location, as per requirements.
    var hasUserSeenLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MapView Setup
        mapView?.delegate = self
        
        // View Model Setup
        viewModel?.delegate = self
        // Ensure tracking is started now, so the access request is seen on this screen.
        viewModel?.startTrackingUser()
        viewModel?.refresh()
        
        searchBar.delegate = self

        // TODO
//        searchController.searchBar = searchBar
//        searchController.searchResultsUpdater = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Ask for permission if it's not availablee
        guard viewModel?.locationManager.locationAccessWasDenied != true else {
            showLocationAccessError()
            return
        }
    }
    
    // MARK: Show 'refreshing' state in UI
    
    // While making refresh API calls, show the user a loading state
    func startRefreshingUI() {
        searchBar.isUserInteractionEnabled = false
        mapView.isUserInteractionEnabled = false
        addButton.isEnabled = false
        reloadButton.isEnabled = false
        jumpToLocationButton.isEnabled = false
        expandButton.isEnabled = false
        activityIndicator.startAnimating()
    }
    
    // Set the UI to be used again
    func finishRefreshingUI() {
        searchBar.isUserInteractionEnabled = true
        mapView.isUserInteractionEnabled = true
        addButton.isEnabled = true
        reloadButton.isEnabled = true
        jumpToLocationButton.isEnabled = true
        expandButton.isEnabled = true
        activityIndicator.stopAnimating()
    }
    
    // Show an alert asking the user to enable location access
    func showLocationAccessError() {
        let locationPermissionCoordinator = LocationPermissionErrorCoordinator(parentViewController: self, message: "Please allow location access in Settings in order to use this app") { result in
            switch (result) {
            case .changeSettings:
                let settingsUrl = URL(string: UIApplication.openSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    //                            UIApplication.sharedApplication().openURL(url)
                }
            case .ignore:
                // User ignored the request, so nothing to do.
                ()
            }
        }
        locationPermissionCoordinator.start()
    }

    // MARK: IBActions
    
    // Reload button
    @IBAction func reloadPressed(_ sender: Any) {
        // Ask the VM to refresh the service data
        viewModel?.refresh()
    }
    
    // Plus button pressed
    @IBAction func addPressed(_ sender: Any) {
        guard let viewModel = viewModel else { return }
        
        // If not given access, show specific error
        guard !viewModel.locationManager.locationAccessWasDenied else {
            showLocationAccessError()
            return
        }
        
        // Ensure we know where the user is
        guard let userLocation = viewModel.userLocation else {
            // If we don't, show an error
            let errorCoordinator = ErrorCoordinator(parentViewController: self, message: "Location not available", completionHandler: nil)
            errorCoordinator.start()
            return
        }

        // Call the coordinator to show the prompt to add a note
        let addNoteCoordinator = NoteCoordinator(parentViewController: self, defaultContent: nil, completionHandler: { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .cancelled:
                // Was cancelled, so do nothing
                ()
            case .finished(text: let text):
                // Is empty? do nothing.
                guard let text = text, !text.isEmpty else {
                    return
                }
                let newRemark = Remark(remarkID: 0, latitude: userLocation.latitude, longitude: userLocation.longitude, user: weakSelf.viewModel?.username ?? "", note: text)
                weakSelf.viewModel?.add(remark: newRemark)
            }
        })
        addNoteCoordinator.start()
    }
    
    // Called when the user presses the compass icon
    @IBAction func jumpToLocationPressed(_ sender: Any) {
        guard let viewModel = viewModel else { return }
        
        // If not given access, show specific error
        guard !viewModel.locationManager.locationAccessWasDenied else {
            showLocationAccessError()
            return
        }

        // Ensure we know where the user is
        guard viewModel.userLocation != nil else {
            // If we don't, show an error
            let errorCoordinator = ErrorCoordinator(parentViewController: self, message: "Location not available", completionHandler: nil)
            errorCoordinator.start()
            return
        }

        guard let locationAnnotation = mapView.annotations.first(where: { $0 is UserLocationAnnotation}) else {
            return
        }
        
        mapView.showAnnotations([locationAnnotation], animated: true)
    }
    
    // User wants to see all markers
    @IBAction func expandPressed(_ sender: Any) {
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
}

// MARK: UISearchBarDelegate
extension MapViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // TODO
    }
}

// MARK: MKMapViewDelegate

extension MapViewController : MKMapViewDelegate {
    struct Constant {
        static let pinAnnotationReuseIdentifier = "CustomPinAnnotation"
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Ensure we dequeue a reusable view if possible, for performance reasons.
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constant.pinAnnotationReuseIdentifier) as? MKAnnotationView ?? MKAnnotationView(annotation: annotation, reuseIdentifier: Constant.pinAnnotationReuseIdentifier)
        annotationView.canShowCallout = true
        
        // If this is a note annotation
        if annotation is RemarkAnnotation {
            // Prepare a button to put on the right side
            let button = UIButton(type: .detailDisclosure)
            annotationView.rightCalloutAccessoryView = button
        }

        // Setup the pin colour
        if let pinStyleAnnotation = annotation as? PinStyleContainer {
            annotationView.image = pinStyleAnnotation.pinStyle.image
            annotationView.tintColor = pinStyleAnnotation.pinStyle.colour
        }

        annotationView.canShowCallout = true
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let remarkAnnotation = view.annotation as? RemarkAnnotation else {
            return
        }
        
        // Show actions available
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak self] action in
            guard let weakSelf = self else { return }
            // Call the coordinator to show the prompt to edit a note
            let addNoteCoordinator = NoteCoordinator(parentViewController: weakSelf, defaultContent: remarkAnnotation.remark.note, completionHandler: { result in
                switch result {
                case .cancelled:
                    // Was cancelled, so do nothing
                    ()
                case .finished(text: let text):
                    // Is empty? do nothing.
                    guard let text = text, !text.isEmpty else {
                        return
                    }
                    let remark = remarkAnnotation.remark
                    let editedRemark = Remark(remarkID: remark.remarkID, latitude: remark.latitude, longitude: remark.longitude, user: remark.user, note: text)
                    weakSelf.viewModel?.update(remark: editedRemark)
                }
            })
            addNoteCoordinator.start()
        }))
        
        // Allow deleting if you are the owner of the remark
        if remarkAnnotation.remark.user == viewModel?.username {
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] action in
                self?.viewModel?.delete(uniqueId: remarkAnnotation.remark.remarkID)
            }))
        }
        
        // Cancel button
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: MapViewModelDelegate

extension MapViewController : MapViewModelDelegate {
    // Show the user we are refreshing UI
    func didStartRefreshing() {
        startRefreshingUI()
    }
    // Set the UI back to normal
    func didEndRefreshing() {
        finishRefreshingUI()
    }
    // Refresh the annotations in the map
    func didChangeRemarks() {
        guard let viewModel = viewModel else { return }
        // Clear all annotations
        mapView.removeAnnotations(mapView.annotations)
        // Add the user's location
        if let userLocation = viewModel.userLocation {
            let userLocationAnnotation = UserLocationAnnotation()
            userLocationAnnotation.coordinate = userLocation
            mapView.addAnnotation(userLocationAnnotation)
        }
        // Add all current remarks
        mapView.addAnnotations(viewModel.currentRemarks.asAnnotations(for: viewModel.username))
    }
    
    func didEncounterError(description: String) {
        let errorCoordinator = ErrorCoordinator(parentViewController: self, message: description, completionHandler: nil)
        errorCoordinator.start()
        return
    }
    
    func userDidChangeLocation() {
        // Ensure we have a valid current location
        guard let userLocation = viewModel?.userLocation else {
            return
        }
        // Remove any existing annotations
        let oldLocationAnnotation = mapView.annotations.first(where: { $0 is UserLocationAnnotation})
        if let oldLocationAnnotation = oldLocationAnnotation {
            mapView.removeAnnotation(oldLocationAnnotation)
        }
        
        // Add the location again, to update it.
        let userLocationAnnotation = UserLocationAnnotation()
        userLocationAnnotation.coordinate = userLocation
        mapView.addAnnotation(userLocationAnnotation)
        
        // Zoom to show the user's location if it's the first time
        if !hasUserSeenLocation {
            mapView.showAnnotations([userLocationAnnotation], animated: true)
            hasUserSeenLocation = true
        }
    }
    
}

// MARK: Remark Utilities

extension Array where Element == Remark {
    func asAnnotations(for username: String) -> [MKAnnotation] {
        return self.map { remark in
            let annotation = RemarkAnnotation(coordinate: remark.asCoordinate(), remark: remark)
            annotation.title = remark.user
            annotation.subtitle = remark.note
            annotation.isOwn = remark.user == username
            return annotation
        }
    }
}

extension Remark {
    func asCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
