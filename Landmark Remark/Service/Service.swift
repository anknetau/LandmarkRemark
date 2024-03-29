//
//  Service.swift
//  Landmark Remark
//
//  Created by Andres Kievsky on 18/8/19.
//  Copyright © 2019 Andres Kievsky. All rights reserved.
//

import Foundation

/// The service this app uses, as a protocol, so that it can be fulfilled by different implementations.
/// The services are self-explanatory.
protocol Service {
    func add(remark: Remark, completionHandler: @escaping (Result<Int, ServiceError>) -> Void)
    func delete(uniqueId: Int, completionHandler: @escaping (Result<Int, ServiceError>) -> Void)
    func listAll(completionHandler: @escaping (Result<[Remark], ServiceError>) -> Void)
    func search(string: String, completionHandler: @escaping (Result<[Remark], ServiceError>) -> Void)
    func update(remark: Remark, completionHandler: @escaping (Result<Int, ServiceError>) -> Void)
}

/// Possible service errors

enum ServiceError : Error {
    case internalError
    case responseError
}
