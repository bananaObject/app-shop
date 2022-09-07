//
//  ResponseProductModel.swift
//  shop
//
//  Created by Ke4a on 07.09.2022.
//

import Foundation

struct  ResponseProductModel: Decodable {
    let result: Int
    let productName: String
    let productPrice: Int
    let productDescription: String

    enum CodingKeys: String, CodingKey {
        case result
        case productName = "product_name"
        case productPrice = "product_price"
        case productDescription = "product_description"
    }
}
