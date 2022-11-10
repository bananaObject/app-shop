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
    case clientError(_ status: Int, _ data: Data)
    case unknown

    // MARK: - Computed Properties

    /// Custom messages.
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .invalidURL:
            return "invalid URL"
        case .noResponse:
            return "no response"
        case .parseError:
            return "parse error"
        case .unexpectedStatusCode:
            return "unexpected statusCode"
        default:
            return "uknow error"
        }
    }
}
