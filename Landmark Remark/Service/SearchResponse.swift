//
//  SearchResponse.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 21/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import Foundation

// Models a response from the API's search endpoint to be received
struct SearchResponse : Decodable {
    var responseCode: Int
    var payload: [Remark]
}
