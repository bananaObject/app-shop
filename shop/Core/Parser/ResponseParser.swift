//
//  ResponseParser.swift
//  shop
//
//  Created by Ke4a on 31.08.2022.
//

import Foundation

protocol ResponseParserProtocol: AnyObject {
    associatedtype Model: Decodable

    func decode(data: Data) throws -> Model

    @available(iOS 13.0.0, *)
    func decode(data: Data) async throws -> Model
}

class ResponseParser<T: Decodable>: ResponseParserProtocol {
    private let decoder = JSONDecoder()

    func decode(data: Data) throws -> T {
        let json: [String: Any]? = try JSONSerialization.jsonObject(
            with: data,
            options: .mutableContainers
        ) as? [String: Any]
        let data = try JSONSerialization.data(withJSONObject: json as Any)
        return try decoder.decode(T.self, from: data)
    }

    @available(iOS 13.0.0, *)
    func decode(data: Data) async throws -> T {
        let json: [String: Any]? = try JSONSerialization.jsonObject(
            with: data,
            options: .mutableContainers
        ) as? [String: Any]
        let itemTask = Task<T, Error> {
            let data = try JSONSerialization.data(withJSONObject: json as Any)
            return try decoder.decode(T.self, from: data)
        }

        return try await itemTask.value
    }
}
