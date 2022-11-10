//
//  ResponseResultModel.swift
//  shop
//
//  Created by Ke4a on 31.08.2022.
//

import Foundation

/// Network response auth.
struct ResponseLoginModel: Decodable {
    let user: UserModel
    let authToken: String

    enum CodingKeys: String, CodingKey {
        case user
        case authToken = "auth_token"
    }

    struct UserModel: Decodable {
        let id: Int
        let login: String
        let firstname: String
        let lastname: String
    }
}
