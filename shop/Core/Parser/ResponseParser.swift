//
//  ResponseParser.swift
//  shop
//
//  Created by Ke4a on 31.08.2022.
//

import Foundation

/// Decoder for response data from the network.
protocol ResponseParserProtocol: AnyObject {
    associatedtype Model: Decodable

    /// Decodes the server response date.
    /// - Parameter data: Response data.
    /// - Returns: Associated type model.
    func decode(data: Data) throws -> Model

    @available(iOS 13.0.0, *)
    /// Decodes the server response date.
    /// Support async / iOS 13.
    /// - Parameter data: Response data.
    /// - Returns: Associated type model.
    func decode(data: Data) async throws -> Model
}

class ResponseParser<T: Decodable>: ResponseParserProtocol {
    // MARK: - Private Properties

    private let decoder = JSONDecoder()

    // MARK: - Public Methods
    
    func decode(data: Data) throws -> T {
        return try decoder.decode(T.self, from: data)
    }

    @available(iOS 13.0.0, *)
    func decode(data: Data) async throws -> T {
        let itemTask = Task<T, Error> {
            return try decoder.decode(T.self, from: data)
        }

        return try await itemTask.value
    }
}
