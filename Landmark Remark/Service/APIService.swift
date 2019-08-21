//
//  APIService.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 21/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import Foundation

/// A service that points to the actual API.

class APIService : Service {
    
    private struct UrlString {
        static let listAll = "https://api.kumulos.com/v1/data/9543_10534_remarks/"
    }
    // Add a new remark
    func add(remark: Remark, completionHandler: @escaping (Result<Int, ServiceError>) -> Void) {
        // Call back with unique ID created
        completionHandler(.success(1))
    }

    // Delete a remark by ID
    func delete(uniqueId: Int, completionHandler: @escaping (Result<Int, ServiceError>) -> Void) {
        completionHandler(.success(1))
    }

    // List all existing remarks
    func listAll(completionHandler: @escaping (Result<[Remark], ServiceError>) -> Void) {
        let expectedStatusCode = 200
        let urlString = UrlString.listAll
        
        // Construct the URL
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.internalError))
            return
        }
        
        // Create a request with the required headers
        var request = URLRequest(url: url)
        request.setAuthentication()

        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Ensure we have something returned
            guard let data = data else {
                completionHandler(.failure(.responseError))
                return
            }
            // Decode the JSON result
            let jsonDecoder = JSONDecoder()
            let jsonResult = try? jsonDecoder.decode([Remark].self, from: data)
            guard let jsonList = jsonResult else {
                completionHandler(.failure(.jsonDecoderError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == expectedStatusCode else {
                    completionHandler(.failure(.responseError))
                    return
            }

            // Successful request! Yay!
            completionHandler(.success(jsonList))
        }
        
        // Start the request
        dataTask.resume()
    }

    // Search by text
    func search(string: String, completionHandler: @escaping (Result<[Remark], ServiceError>) -> Void) {
        completionHandler(.success([]))
    }

    // Update an existing remark
    func update(remark: Remark, completionHandler: @escaping (Result<Int, ServiceError>) -> Void) {
        completionHandler(.success(1))
    }
}

extension URLRequest {
    private struct Auth {
        static let apiKey = "078ea361ad4445b6e317bccb4c767ecb88607cf90bf33153e4985b26acc51766"
    }
    /// Add basic auth required for API calls
    mutating func setAuthentication() {
        let base64String = Auth.apiKey.data(using: .utf8)?.base64EncodedString() ?? ""
        self.setValue("Basic: \(base64String)", forHTTPHeaderField: "Authorization")
    }
}
