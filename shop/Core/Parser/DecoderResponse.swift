//
//  DecoderResponse.swift
//  shop
//
//  Created by Ke4a on 31.08.2022.
//

import Foundation

/// Decoder for response data from the network.
protocol DecoderResponseProtocol: AnyObject {
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

    func decodeError(data: Data) throws -> ResponseErrorModel
}

final class DecoderResponse<T: Decodable>: DecoderResponseProtocol {
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

    func decodeError(data: Data) throws -> ResponseErrorModel {
        return try decoder.decode(ResponseErrorModel.self, from: data)
    }
}
