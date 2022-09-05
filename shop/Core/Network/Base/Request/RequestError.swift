//
//  RequestError.swift
//  shop
//
//  Created by Ke4a on 31.08.2022.
//

import Foundation

enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case parseError
    case unexpectedStatusCode
    case unknown

    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        default:
            return "Unknown error"
        }
    }
}
