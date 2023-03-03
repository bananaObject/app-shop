//
//  BasketViewCellModel.swift
//  shop
//
//  Created by Ke4a on 25.02.2023.
//

import Foundation

struct BasketViewCellModel {
    let id: Int
    let name: String
    let price: Int
    var quantity: Int
    let imageUrl: String?
    var imageData: Data?
}
