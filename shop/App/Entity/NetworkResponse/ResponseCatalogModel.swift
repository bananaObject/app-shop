//
//  ResponseCatalogModel.swift
//  shop
//
//  Created by Ke4a on 07.09.2022.
//

import Foundation

/// Network response catalog.
struct ResponseCatalogModel: Decodable {
    let pageNumber: Int
    let maxPage: Int
    let products: [ResponseProductModel]

    enum CodingKeys: String, CodingKey {
        case pageNumber = "page_number"
        case maxPage = "max_page"
        case products
    }
}
