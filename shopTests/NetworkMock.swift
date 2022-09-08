//
//  NetworkMock.swift
//  ShopTests
//
//  Created by Ke4a on 07.09.2022.
//

import Foundation
@testable import shop

/// Network layer simulation.
class NetworkMock: NetworkProtocol {
    // MARK: - Properties

    /// Сlosure request completion.
    var completionRequest: (() -> Void)?

    /// Repeated request will give a new info.
    var firstTime = true

    // MARK: - Methods

    /// Request mock.
    /// - Parameters:
    ///   - endpoint: Request adress.
    ///   - completion: Closure type Result.
    func fetch(_ endpoint: NetworkEndpoint, _ completion: @escaping (Result<Data, RequestError>) -> Void) {
        var json: String

        switch endpoint {
        case .registration:

            json = """
                          {"result": \(firstTime ? 1 : 0), "userMessage": "Регистрация прошла успешно!"}
                        """
        case .login:
            json = """
                         { "result": \(firstTime ? 1 : 0),
                           "user": {
                             "id_user": 123, "user_login": "geekbrains", "user_name": "John",
                             "user_lastname": "Doe"
                           },
                           "authToken": "some_authorizaion_token" }
                        """
        case .logout, .changeUserData:
            json = """
                        {"result": \(firstTime ? 1 : 0) }
                        """
        case .catalog:
            json = firstTime ?
                        """
                         [ { "id_product": 123, "product_name": "Ноутбук", "price": 45600 },
                           { "id_product": 456, "product_name": "Мышка", "price": 1000 } ]
                        """
            :
                        """
                         []
                        """
        case .product:
            json = """
                         { "result": \(firstTime ? 1 : 0), "product_name": "Ноутбук",
                           "product_price": 45600,  "product_description": "Мощный игровой ноутбук" }
                        """
        }

        guard let data = json.data(using: .utf8) else { return }
        completion(.success(data))
        // Request completion call
        self.completionRequest?()
        firstTime = false
    }

    @available(iOS 13.0.0, *)
    /// Request mock.
    /// - Parameter endpoint: Request adress.
    /// - Returns: Response data.
    func fetch(_ endpoint: NetworkEndpoint) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            // Чтоб не городить много текста, просто вызываю функцию для мока
            self.fetch(endpoint) { result in
                switch result {
                case.success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
