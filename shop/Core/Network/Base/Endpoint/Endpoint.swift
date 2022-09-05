//
//  Endpoint.swift
//  shop
//
//  Created by Ke4a on 31.08.2022.
//

import Foundation

enum RequestMethod: String {
    case GET
    case POST
}

protocol Endpoint {
    var baseURL: URLComponents { get }
    var path: String { get }
    var method: RequestMethod { get }
    var params: [URLQueryItem]? { get }
}
