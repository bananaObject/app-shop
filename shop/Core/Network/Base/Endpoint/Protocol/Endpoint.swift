//
//  Endpoint.swift
//  shop
//
//  Created by Ke4a on 06.09.2022.
//

import Foundation

protocol Endpoint {
    var baseURL: URLComponents { get }
    var path: String { get }
    var method: RequestMethod { get }
    var params: [URLQueryItem]? { get }
}
