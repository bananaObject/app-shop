//
//  ResponseReviewModel.swift
//  shop
//
//  Created by Ke4a on 13.09.2022.
//

import Foundation

struct ResponseReviewModel: Codable {
    let text: String
    let userName: String
    let idUser: Int
    let idReview: Int

    enum CodingKeys: String, CodingKey {
        case text
        case userName = "user_name"
        case idUser = "id_user"
        case idReview = "id_review"
    }
}
