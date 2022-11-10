//
//  DecoderResponse.swift
//  shop
//
//  Created by Ke4a on 31.08.2022.
//

import Foundation

/// Decoder for response data from the network.
protocol DecoderResponseProtocol: AnyObject {
    /// Decodes the server response date.
    /// - Parameter data: Response data.
    /// - Parameter model: decode model
    /// - Returns: decoding responsse.
    func decode<U: Decodable>(data: Data, model: U.Type) throws -> U

    @available(iOS 13.0.0, *)
    /// Decodes the server response date.
    /// Support async / iOS 13.
    /// - Parameter data: Response data.
    /// - Parameter model: decode model
    /// - Returns: Associated type model.
    func decode<U: Decodable>(data: Data, model: U.Type) async throws -> U

    func decodeError(data: Data) throws -> NetworkErrorModel
}

final class DecoderResponse: DecoderResponseProtocol {
    // MARK: - Private Properties

    private let decoder = JSONDecoder()

    // MARK: - Public Methods
    
    func decode<U: Decodable>(data: Data, model: U.Type) throws -> U {
        return try decoder.decode(U.self, from: data)
    }

    @available(iOS 13.0.0, *)
    func decode<U: Decodable>(data: Data, model: U.Type) async throws -> U {
        let itemTask = Task<U, Error> {
            return try decoder.decode(U.self, from: data)
        }

        return try await itemTask.value
    }

    func decodeError(data: Data) throws -> NetworkErrorModel {
        return try decoder.decode(NetworkErrorModel.self, from: data)
    }
}
