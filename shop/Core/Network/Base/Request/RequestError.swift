//
//  RequestError.swift
//  shop
//
//  Created by Ke4a on 31.08.2022.
//

import Foundation

/// Network Error.
enum RequestError: Error {
    // MARK: - Cases
    
    case decode
    case invalidURL
    case noResponse
    case parseError
    case unexpectedStatusCode
    case unknown

    // MARK: - Computed Properties

    /// Custom messages.
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        default:
            return "Unknown error"
        }
    }
}
