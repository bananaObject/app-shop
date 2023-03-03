//
//  ResponseProductModel.swift
//  shop
//
//  Created by Ke4a on 07.09.2022.
//

import Foundation

/// Network response product.
struct ResponseProductModel: Decodable {
    let id: Int
    let category: Int
    let name: String
    let price: Int
    let description: String?
    let lastReview: ResponseReviewModel?
    var qt: Int?
    var imageSmall: String?
    var images: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case category
        case name
        case price
        case description
        case lastReview = "last_review"
        case qt
        case imageSmall = "image"
        case images
    }
}
