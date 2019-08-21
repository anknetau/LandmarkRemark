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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: Show 'refreshing' state in UI
    
    func startRefreshingUI() {
        searchBar.isUserInteractionEnabled = false
        mapView.isUserInteractionEnabled = false
        addButton.isEnabled = false
        reloadButton.isEnabled = false
        jumpToLocationButton.isEnabled = false
        expandButton.isEnabled = false
        activityIndicator.startAnimating()
    }
    
    func finishRefreshingUI() {
        searchBar.isUserInteractionEnabled = true
        mapView.isUserInteractionEnabled = true
        addButton.isEnabled = true
        reloadButton.isEnabled = true
        jumpToLocationButton.isEnabled = true
        expandButton.isEnabled = true
        activityIndicator.stopAnimating()
    }
    
    // MARK: IBActions

    // Reload button
    @IBAction func reloadPressed(_ sender: Any) {
        // Ask the VM to refresh the service data
        viewModel?.refresh()
    }
    
    // Plus button pressed
    @IBAction func addPressed(_ sender: Any) {
        // Ensure we know where the user is
        guard let userLocation = viewModel?.userLocation else {
            // TODO - show error
            return
        }
        // Call the coordinator to show the prompt to add a note
        let addNoteCoordinator = AddNoteCoordinator(parentViewController: self, completionHandler: { [weak self] result in
            switch result {
            case .cancelled:
                // Was cancelled, so do nothing
                ()
            case .finished(text: let text):
                // Is empty? do nothing.
                guard let text = text, !text.isEmpty else {
                    return
                }
                let newRemark = Remark(remarkID: 0, latitude: userLocation.latitude, longitude: userLocation.longitude, user: self?.viewModel?.username ?? "", note: text)
                self?.viewModel?.addRemark(remark: newRemark)
            }
        })
        addNoteCoordinator.start()
    }
    
    // Called when the user presses the compass icon
    @IBAction func jumpToLocationPressed(_ sender: Any) {
        // Ensure we know where the user is
        guard let userLocation = viewModel?.userLocation else {
            // TODO - show error
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

class AnnotationView: MKAnnotationView {
}

class UserLocationAnnotation: NSObject, MKAnnotation, PinStyleContainer {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var title: String? = "This is where you are"
    var subtitle: String? = nil
}

class RemarkAnnotation: NSObject, MKAnnotation, PinStyleContainer {
    var coordinate: CLLocationCoordinate2D
    var remark: Remark
    var title: String?
    var subtitle: String?
    init(coordinate: CLLocationCoordinate2D, remark: Remark) {
        self.coordinate = coordinate
        self.remark = remark
    }
}

extension MapViewController : MKMapViewDelegate {
    struct Constant {
        static let pinAnnotationReuseIdentifier = "CustomPinAnnotation"
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Ensure we dequeue a reusable view if possible, for performance reasons.
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constant.pinAnnotationReuseIdentifier) as? MKPinAnnotationView ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constant.pinAnnotationReuseIdentifier)
        annotationView.canShowCallout = true
        if let annotationView = annotationView as? MKPinAnnotationView,
            let pinStyleAnnotation = annotation as? PinStyleContainer {
            annotationView.pinTintColor = pinStyleAnnotation.pinStyle.colour
        }
//        annotationView.image =
        
        
        annotationView.canShowCallout = true
        return annotationView
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
    func didChangeRemarks() {
        // TODO - WIP
        guard let viewModel = viewModel else { return }
        mapView.removeAnnotations(mapView.annotations)
        if let userLocation = viewModel.userLocation {
            let userLocationAnnotation = UserLocationAnnotation()
            userLocationAnnotation.coordinate = userLocation
            mapView.addAnnotation(userLocationAnnotation)
        }
        mapView.addAnnotations(viewModel.currentRemarks.asAnnotations())
    }
    
    func didEncounterError(description: String) {
        // TODO - WIP
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
    func asAnnotations() -> [MKAnnotation] {
        return self.map { remark in
            let annotation = RemarkAnnotation(coordinate: remark.asCoordinate(), remark: remark)
            annotation.title = remark.user
            annotation.subtitle = remark.note
            return annotation
        }
    }
}

extension Remark {
    func asCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
