//
//  Remark.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 18/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import Foundation

// Models an entry (i.e., a landmark's remark) in the app.
struct Remark : Codable {
    let uniqueId: Int
    let latitude: Double
    let longitude: Double
    let user: String
    let note: String
}
