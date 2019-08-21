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
    // Available URLs
    private struct UrlString {
        static let restBase = "https://api.kumulos.com/v1/data/9543_10534_remarks/"
        static let apiBase = "https://api.kumulos.com/b2.2/{apikey}/search.json"
    }
    
    // Other constants
    private struct Constant {
        static let contentType = "Content-Type"
        static let applicationJson = "application/json"
        static let formUrlEncoded = "application/x-www-form-urlencoded"
        static let successfulApiResponseCode = 1
        static let apiKeyPlaceholder = "{apikey}"
        struct StatusCode {
            static let ok = 200
            static let created = 201
            static let noContent = 204
        }
    }

    // Add a new remark
    func add(remark: Remark, completionHandler: @escaping (Result<Int, ServiceError>) -> Void) {
        addOrUpdate(remark: remark, updateID: nil, completionHandler: completionHandler)
    }
    
    // Delete a remark by ID
    func delete(uniqueId: Int, completionHandler: @escaping (Result<Int, ServiceError>) -> Void) {
        // Construct the URL
        let urlString = UrlString.restBase + String(uniqueId)
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.internalError))
            return
        }
        
        // Create a request with the required headers
        var request = URLRequest(url: url)
        request.setRestAuthentication()
        request.httpMethod = "DELETE"
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Did we receive an error? Is the status code as expected?
            guard error == nil,
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == Constant.StatusCode.noContent else {
                    completionHandler(.failure(.responseError))
                    return
            }
            
            // Successful request! Yay!
            completionHandler(.success(1))
        }
        
        // Start the request
        dataTask.resume()
    }

    // List all existing remarks
    func listAll(completionHandler: @escaping (Result<[Remark], ServiceError>) -> Void) {
        let urlString = UrlString.restBase
        
        // Construct the URL
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.internalError))
            return
        }
        
        // Create a request with the required headers
        var request = URLRequest(url: url)
        request.setRestAuthentication()

        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Did we receive an error?
            guard error == nil else {
                completionHandler(.failure(.responseError))
                return
            }

            // Check the response status code
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == Constant.StatusCode.ok else {
                    completionHandler(.failure(.responseError))
                    return
            }

            // Decode the JSON result
            guard let jsonList = data?.decodeRemarks() else {
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
        // Setup the URL
        let urlString = UrlString.apiBase.replacingOccurrences(of: Constant.apiKeyPlaceholder, with: Auth.apiKey)
        
        // Construct the URL
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.internalError))
            return
        }
        
        // Create a request object with the required headers for the API request
        var request = URLRequest(url: url)
        request.setApiAuthenticationAndHeaders()
        request.httpMethod = "POST"

        // Setup search value with www-form-encoded.
        let encodedString = string.formEncoded()
        request.httpBody = "search=\(encodedString)".data(using: .utf8)
        request.setValue(Constant.formUrlEncoded, forHTTPHeaderField: Constant.contentType)
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Did we receive an error?
            guard error == nil else {
                completionHandler(.failure(.responseError))
                return
            }
            
            // Check the response status code
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == Constant.StatusCode.ok else {
                    completionHandler(.failure(.responseError))
                    return
            }
            
            // Decode the JSON result, ensure it was successful
            guard let searchResponse = data?.decodeSearchResponse(),
                searchResponse.responseCode == Constant.successfulApiResponseCode else {
                completionHandler(.failure(.responseError))
                return
            }
            
            // Successful request! Yay!
            completionHandler(.success(searchResponse.payload))
        }
        
        // Start the request
        dataTask.resume()
    }

    // Update an existing remark
    func update(remark: Remark, completionHandler: @escaping (Result<Int, ServiceError>) -> Void) {
        addOrUpdate(remark: remark, updateID: remark.remarkID, completionHandler: completionHandler)
    }
    
    // MARK: Private functionality
    
    /// Method used to add a new remark or update an existing one
    /// - parameter updateID: The ID of the remark to update. If this parameter is nil, the remark will be added as a new one.
    private func addOrUpdate(remark: Remark, updateID: Int?, completionHandler: @escaping (Result<Int, ServiceError>) -> Void) {
        // Determine the URL to use.
        let urlString: String = {
            var urlString = UrlString.restBase
            
            // Append the ID if this is an update operation
            if let updateID = updateID {
                urlString = urlString + String(updateID)
            }
            
            return urlString
        }()

        // Construct the URL
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.internalError))
            return
        }
        
        // Create a request with the required headers
        var request = URLRequest(url: url)
        request.setRestAuthentication()
        request.httpMethod = "POST"
        request.httpBody = remark.jsonEncoded()
        request.setValue(Constant.applicationJson, forHTTPHeaderField: Constant.contentType)
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Did we receive an error?
            guard error == nil else {
                completionHandler(.failure(.responseError))
                return
            }
            
            // Check the response status code
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == Constant.StatusCode.created else {
                    completionHandler(.failure(.responseError))
                    return
            }
            
            // Successful request! Yay!
            completionHandler(.success(1))
        }
        
        // Start the request
        dataTask.resume()
    }
}

// MARK: Functions to setup auth in requests

// Authentication-related constants
struct Auth {
    static let restApiKey = "078ea361ad4445b6e317bccb4c767ecb88607cf90bf33153e4985b26acc51766"
    static let apiKey = "0498c920-2007-430a-83f5-33ff9bb17f76"
    static let appSecret = "cYZJ2L8uTBzsGjFfWYu1pVs8rYtq/v7pe1tp"
}

extension URLRequest {
    private struct Constant {
        static let authorization = "Authorization"
    }
    /// Add basic auth required for Kumulos REST calls
    mutating func setRestAuthentication() {
        let base64String = Auth.restApiKey.data(using: .utf8)?.base64EncodedString() ?? ""
        self.setValue("Basic: \(base64String)", forHTTPHeaderField: Constant.authorization)
    }
    /// Add basic auth required for Kumulos API calls
    mutating func setApiAuthenticationAndHeaders() {
        let restString = "\(Auth.apiKey):\(Auth.appSecret)"
        let base64String = restString.data(using: .utf8)?.base64EncodedString() ?? ""
        self.setValue("Basic \(base64String)", forHTTPHeaderField: Constant.authorization)
    }
}

// MARK: Utility functions to encode and decode JSON.

extension Data {
    /// JSON to array of Remark objects
    func decodeRemarks() -> [Remark]? {
        let jsonDecoder = JSONDecoder()
        return try? jsonDecoder.decode([Remark].self, from: self)
    }
    func decodeSearchResponse() -> SearchResponse? {
        let jsonDecoder = JSONDecoder()
        return try? jsonDecoder.decode(SearchResponse.self, from: self)
    }
}

extension Remark {
    /// Remark object to Data
    func jsonEncoded() -> Data? {
        let jsonEncoder = JSONEncoder()
        return try? jsonEncoder.encode(self)
    }
}

extension String {
    /// Encode for submission in form
    func formEncoded() -> String {
        // URL encode but some characters need to remain the same.
        var allowedCharacters = CharacterSet.urlQueryAllowed
        allowedCharacters.remove("+")
        allowedCharacters.remove("/")
        allowedCharacters.remove("?")
        // We need to keep this one so we can encode afterwards, as + needs to be encoded first.
        allowedCharacters.insert(" ")
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)?.replacingOccurrences(of: " ", with: "+") ?? ""
    }
}
