//
//  RemarkAnnotation.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 21/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import Foundation
import MapKit

// MapKit Annotation for a remark

class RemarkAnnotation: NSObject, MKAnnotation, PinStyleContainer {
    var coordinate: CLLocationCoordinate2D
    var remark: Remark
    var title: String?
    var subtitle: String?
    var isOwn = false
    init(coordinate: CLLocationCoordinate2D, remark: Remark) {
        self.coordinate = coordinate
        self.remark = remark
    }
}
