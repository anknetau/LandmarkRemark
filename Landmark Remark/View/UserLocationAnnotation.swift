//
//  UserLocationAnnotation.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 21/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import Foundation
import MapKit

// MapKit Annotation for the current user location

class UserLocationAnnotation: NSObject, MKAnnotation, PinStyleContainer {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var title: String? = "This is where you are"
    var subtitle: String? = nil
}
