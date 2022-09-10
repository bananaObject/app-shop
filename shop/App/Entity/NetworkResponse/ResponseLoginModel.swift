//
//  ResponseResultModel.swift
//  shop
//
//  Created by Ke4a on 31.08.2022.
//

import Foundation

struct UserResponse: Decodable {
    let id: Int
    let login: String
    let firstname: String
    let lastname: String

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case firstname
        case lastname
    }
}

struct ResponseLoginModel: Decodable {
    let user: UserResponse
    let authToken: String

    enum CodingKeys: String, CodingKey {
        case user
        case authToken = "auth_token"
    }
}
