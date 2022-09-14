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
    case logout
    case registration(_ info: RequestUserInfo)
    case changeUserData(_ userData: RequestUserInfo)
    case catalog(_ page: Int, _ category: Int?)
    case product(_ id: Int)
    case reviews(_ productId: Int, _ page: Int)
    case addReview(_ idProduct: Int, _ text: String)
    case deleteReview(_ idProduct: Int, _ idReview: Int)
}

extension NetworkEndpoint: Endpoint {
    private var authToken: String {
        // В будущем кейчейн сделаю
        "905ef89d-25a4-4255-902f-fafd4f6a9774"
    }
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
        case .product(let id):
            return "/catalog/product/\(id)"
        case .reviews(let id, _):
            return "/catalog/product/\(id)/reviews"
        case .addReview(let id, _):
            return "/catalog/product/\(id)/review/add"
        case .deleteReview(let id, _):
            return "/catalog/product/\(id)/review/delete"
        }
    }

    var method: RequestMethod {
        switch self {
        case .catalog,
                .product,
                .reviews:
            return .GET
        case .login,
                .logout,
                .registration,
                .changeUserData,
                .addReview,
                .deleteReview:
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
        case .reviews(_, let page):
            base.append(.init(name: "page_number", value: String(page)))
        case .login,
                .logout,
                .registration,
                .changeUserData,
                .product,
                .addReview,
                .deleteReview:
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
        case .logout:
            base["auth_token"] = self.authToken
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
        case .addReview(_, let text):
            base["auth_token"] = self.authToken
            base["text"] = text
        case .deleteReview(_, let id):
            base["auth_token"] = self.authToken
            base["id_review"] = id
        case .catalog,
                .product,
                .reviews:
            return nil
        }

        do {
            return try JSONSerialization.data(withJSONObject: base, options: .sortedKeys)
        } catch {
            return nil
        }
    }
}
