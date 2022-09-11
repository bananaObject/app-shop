//
//  ResponseErrorModel.swift
//  shop
//
//  Created by Ke4a on 10.09.2022.
//

import Foundation

struct ResponseErrorModel: Codable {
    let error: Bool
    let reason: String?
}
