//
//  ResponseCatalogModel.swift
//  shop
//
//  Created by Ke4a on 07.09.2022.
//

import Foundation

struct ResponseCatalogModel: Decodable {
    let idProduct: Int
    let productName: String
    let price: Int

    enum CodingKeys: String, CodingKey {
        case idProduct = "id_product"
        case productName = "product_name"
        case price
    }
}
