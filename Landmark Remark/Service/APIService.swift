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
    private struct Auth {
        static let apiKey = "078ea361ad4445b6e317bccb4c767ecb88607cf90bf33153e4985b26acc51766"
        static let password = ""
        static let protectionHost = "kumulos.com"
        static let port = 443
        static let proto = "https"
        static let realm = "Restricted"
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
        let credential = URLCredential(user: Auth.apiKey, password: Auth.password, persistence: .forSession)
        let space = URLProtectionSpace(host: Auth.protectionHost, port: Auth.port, protocol: Auth.proto, realm: Auth.realm, authenticationMethod: NSURLAuthenticationMethodHTTPBasic)
        URLCredentialStorage.shared.setDefaultCredential(credential, for: space)
        
        guard let url = URL(string: UrlString.listAll) else {
            completionHandler(.failure(.internalError))
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Ensure we have something returned
            guard let data = data else {
                completionHandler(.failure(.responseError))
                return
            }
            // Decode the result
            let jsonDecoder = JSONDecoder()
            let jsonResult = try? jsonDecoder.decode([Remark].self, from: data)
            guard let jsonList = jsonResult else {
                completionHandler(.failure(.jsonDecoderError))
                return
            }

            // Successful request
            completionHandler(.success(jsonList))
        }
        
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
