//
//  ResponseBasketModel.swift
//  shop
//
//  Created by Ke4a on 15.09.2022.
//

import Foundation

struct ResponseBasketModel: Decodable {
    var quantity: Int
    let product: ResponseProductModel
}
