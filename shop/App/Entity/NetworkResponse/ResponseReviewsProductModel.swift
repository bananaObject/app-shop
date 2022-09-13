//
//  ResponseReviewsProductModel.swift
//  shop
//
//  Created by Ke4a on 13.09.2022.
//

import Foundation

struct ResponseReviewsProductModel: Codable {
    let maxPage: Int
    var items: [ResponseReviewModel]

    enum CodingKeys: String, CodingKey {
        case maxPage = "max_page"
        case items
    }
}
