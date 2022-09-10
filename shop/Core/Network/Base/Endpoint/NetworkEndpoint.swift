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
    
    case login(_ loginPass: RequestLogin)
    case logout(_ token: String)
    case registration(_ info: RequestUserInfo)
    case changeUserData(_ userData: RequestUserInfo)
    case catalog(_ page: Int, _ category: Int?)
    case product(_ id: Int)
}

extension NetworkEndpoint: Endpoint {
    // MARK: - Computed Properties
    
    var baseURL: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "toxic-frog-company.herokuapp.com"
        return components
    }
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .logout:
            return "/auth/logout"
        case .registration:
            return "/user/registration"
        case .changeUserData:
            return "/user/changeInfo"
        case .catalog:
            return "/catalog"
        case.product(let id):
            return"/catalog/product/\(id)"
        }
    }

    var method: RequestMethod {
        switch self {
        case .catalog,
                .product:
            return .GET
        case .login,
                .logout,
                .registration,
                .changeUserData:
            return .POST
        }
    }

    var params: [URLQueryItem]? {
        var base: [URLQueryItem] = []

        switch self {
        case .catalog(let page, let category):
            base.append(.init(name: "page_number", value: String(page)))
            if let category = category {
                base.append(.init(name: "id_category", value: String(category)))
            }
        case .login,
                .logout,
                .registration,
                .changeUserData,
                .product:
            return nil
        }

        return base
    }

    var body: Data? {
        var base: [String: Any] = [:]

        switch self {
        case .login(let data):
            base["login"] = data.login
            base["password"] = data.password
        case .logout(let token):
            base["auth_token"] = token
        case .registration(let data),
                .changeUserData(let data):
            base["login"] = data.login
            base["password"] = data.password
            base["firstname"] = data.firstname
            base["lastname"] = data.lastname
            base["email"] = data.email
            base["gender"] = data.gender
            base["credit_card"] = data.creditCard
            base["bio"] = data.bio
        case .catalog,
                .product:
            return nil
        }

        do {
            return try JSONSerialization.data(withJSONObject: base, options: .sortedKeys)
        } catch {
            return nil
        }
    }
}
