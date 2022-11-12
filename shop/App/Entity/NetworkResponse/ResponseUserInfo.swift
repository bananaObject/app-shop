//
//  ResponseUserInfo.swift
//  shop
//
//  Created by Ke4a on 08.11.2022.
//

import Foundation

struct ResponseUserInfo: Decodable {
    var login: String
    var password: String
    var firstname: String
    var lastname: String
    var email: String
    var gender: String
    var creditCard: String
    var bio: String

    enum CodingKeys: String, CodingKey {
        case login
        case password
        case firstname
        case lastname
        case email
        case gender
        case creditCard = "credit_card"
        case bio
    }
}
