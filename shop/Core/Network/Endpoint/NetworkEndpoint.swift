//
//  NetworkEndpoint.swift
//  shop
//
//  Created by Ke4a on 31.08.2022.
//

import Foundation

enum NetworkEndpoint {
    case registration(RequestUserData)
    case login(RequestLoginData)
    case logout(String)
    case changeUserData(RequestUserData)
}

extension NetworkEndpoint: Endpoint {
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
        }

        return base
    }

    var method: RequestMethod {
        switch self {
        case .registration, .login, .logout, .changeUserData:
            return .GET
        }
    }

    var params: [URLQueryItem]? {
        var base: [URLQueryItem] = []

        switch self {
        case .registration(let data),
                .changeUserData(let data):
            base.append(.init(name: "id_user", value: data.id))
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
            base.append(.init(name: "id_user", value: data))
        }
        
        return base
    }
}
