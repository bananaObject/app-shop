//
//  ResponseResultModel.swift
//  shop
//
//  Created by Ke4a on 05.09.2022.
//

import Foundation

struct ResponseResultModel: Codable {
    let result: Int

    func getBoolean() -> Bool {
        return self.result == 1
    }
}
