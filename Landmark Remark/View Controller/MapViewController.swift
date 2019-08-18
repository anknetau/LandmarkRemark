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
    
    let viewModel = MapViewModel()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView?.delegate = self
        
        startCoreLocation()
        checkCoreLocationPermissions()
        
        // View Model Setup
        viewModel.delegate = self
        viewModel.refresh()
    }
    
    func startCoreLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func checkCoreLocationPermissions() {
        guard CLLocationManager.locationServicesEnabled() else {
            // TODO - error
            return
        }
        if CLLocationManager.authorizationStatus() == .denied {
            // TODO - error
        }
    }
}

class AnnotationView: MKAnnotationView {    
}

class Annotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -33, longitude: 151)
    var title: String? = "Sydney alsdkf jalfdk j"
    var subtitle: String? = "My note alkfjalk dfjlak dflka dflkja dflkj adlkfj adlkjf aldjkf alkdjf alkfd lakjd fladjk f"
}

extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
        }
    }
    
}
extension MapViewController : MKMapViewDelegate {
    struct Constant {
        static let pinAnnotationReuseIdentifier = "CustomPinAnnotation"
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Ensure we dequeue a reusable view if possible, for performance reasons.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constant.pinAnnotationReuseIdentifier) ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constant.pinAnnotationReuseIdentifier)
        
        annotationView.canShowCallout = true
        return annotationView
    }
}

extension MapViewController : MapViewModelDelegate {
    func didChangeRemarks() {
        // TODO - WIP
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations([Annotation()])

    }
    func didEncounterError(description: String) {
    }
}

