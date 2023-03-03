//
//  ProductInfoViewModel.swift
//  shop
//
//  Created by Ke4a on 25.02.2023.
//

import Foundation

struct ProductInfoViewModel {
    let id: Int
    let name: String
    let price: Int
    let description: String
    var qt: Int
    let lastReview: ResponseReviewModel?
    var images: [Data]?
}

struct OtherProductInfoViewModel {
    let id: Int
    let name: String
    let price: Int
    var image: String?
    var imageData: Data?
}
