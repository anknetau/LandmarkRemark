//
//  MockData.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 19/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import Foundation

// A series of locations used as mock/test data

struct MockData {
    static let locations: [(Double, Double, String)] = [
        (-33.868759, 151.206660, "Apple Store Sydney"),
        (-33.872102, 151.211483, "Hyde Park"),
        (-33.859660, 151.209003, "Museum of contemporary art"),
        (-33.857174, 151.201203, "Barangaroo Reserve"),
        (-33.847473, 151.209930, "Luna Park"),
        (-33.856889, 151.215140, "Opera House"),
    ]
    static let userLocation: (Double, Double, String) = (-33.886522, 151.211699, "Tigerspike Sydney")
}
