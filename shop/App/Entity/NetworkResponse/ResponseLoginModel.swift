//
//  ResponseResultModel.swift
//  shop
//
//  Created by Ke4a on 31.08.2022.
//

import Foundation

struct UserModel: Codable {
    let idUser: Int
    let userLogin: String
    let userName: String
    let userLastname: String

    enum CodingKeys: String, CodingKey {
        case idUser = "id_user"
        case userLogin = "user_login"
        case userName = "user_name"
        case userLastname = "user_lastname"
    }
}

struct ResponseLoginModel: Codable {
    let result: Int
    let user: UserModel
    let authToken: String

    enum CodingKeys: String, CodingKey {
        case result
        case user
        case authToken
    }
}
