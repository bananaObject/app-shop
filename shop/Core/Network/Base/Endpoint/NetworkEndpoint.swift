//
//  NetworkEndpoint.swift
//  shop
//
//  Created by Ke4a on 31.08.2022.
//

import Foundation

/// Request addresses.
/// Contains computed properties with data for the query.
enum NetworkEndpoint {
    // MARK: - Case

    case registration(RequestUserData)
    case login(RequestLoginData)
    case logout(_ id: Int)
    case changeUserData(_ userData: RequestUserData)
    case catalog(_ page: Int, _ category: Int)
    case product(_ id: Int)
}

extension NetworkEndpoint: Endpoint {
    // MARK: - Computed Properties

    var baseURL: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "raw.githubusercontent.com"
        return components
    }

    var path: String {
        var base = "/GeekBrainsTutorial/online-store-api/master/responses"

        switch self {
        case .registration:
            base += "/registerUser.json"
        case .login:
            base += "/login.json"
        case .logout:
            base += "/logout.json"
        case .changeUserData:
            base += "/changeUserData.json"
        case .catalog:
            base += "/catalogData.json"
        case.product:
            base += "/getGoodById.json"
        }

        return base
    }

    var method: RequestMethod {
        switch self {
        case .registration,
                .login,
                .logout,
                .changeUserData,
                .catalog,
                .product:
            return .GET
        }
    }

    var params: [URLQueryItem]? {
        var base: [URLQueryItem] = []

        switch self {
        case .registration(let data),
                .changeUserData(let data):
            base.append(.init(name: "id_user", value: String(data.id)))
            base.append(.init(name: "username", value: data.username))
            base.append(.init(name: "password", value: data.password))
            base.append(.init(name: "email", value: data.email))
            base.append(.init(name: "gender", value: data.gender))
            base.append(.init(name: "credit_card", value: data.creditCard))
            base.append(.init(name: "bio", value: data.bio))
        case .login(let data):
            base.append(.init(name: "username", value: data.username))
            base.append(.init(name: "password", value: data.password))
        case  .logout(let data):
            base.append(.init(name: "id_user", value: String(data)))
        case .catalog(let page, let category):
            base.append(.init(name: "page_number", value: String(page)))
            base.append(.init(name: "id_category", value: String(category)))
        case .product(let data):
            base.append(.init(name: "id_product", value: String(data)))
        }
        
        return base
    }
}
