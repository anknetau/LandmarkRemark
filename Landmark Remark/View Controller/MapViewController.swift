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
    
    var viewModel: MapViewModel?
    let locationManager = LocationManager.sharedLocationManager

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.startCoreLocation()

        mapView?.delegate = self
        
        
        // View Model Setup
        viewModel?.delegate = self
        // viewModel.refresh() TODO
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    
    // MARK: IBActions

    @IBAction func reloadPressed(_ sender: Any) {
        // Ask the VM to refresh the service data
        viewModel?.refresh()
    }
    
    @IBAction func addPressed(_ sender: Any) {
        // Call the coordinator to show the prompt to add a note
        let addNoteCoordinator = AddNoteCoordinator(parentViewController: self)
        addNoteCoordinator.start()
    }
}

class AnnotationView: MKAnnotationView {
}

class UserLocationAnnotation: NSObject, MKAnnotation, PinStyleContainer {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -33, longitude: 151)
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
    func didChangeRemarks() {
        // TODO - WIP
        guard let viewModel = viewModel else { return }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations([UserLocationAnnotation()])
        mapView.addAnnotations(viewModel.currentRemarks.asAnnotations())
    }
    
    func didEncounterError(description: String) {
        // TODO - WIP
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
