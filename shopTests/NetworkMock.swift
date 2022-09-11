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
    private let jsonEncoder = JSONEncoder()
    // MARK: - Properties

    /// Сlosure request completion.
    var completionRequest: (() -> Void)?

    /// Repeated request will give a new info.
    private var firstTime = true

    // MARK: - Methods

    /// Request mock.
    /// - Parameters:
    ///   - endpoint: Request adress.
    ///   - completion: Closure type Result.
    func fetch(_ endpoint: NetworkEndpoint, _ completion: @escaping (Result<Data, RequestError>) -> Void) {
        var json: String

        switch endpoint {
        case .registration:
            let word = firstTime ?  "Регистрация прошла успешно!" : "Succes"

            json = """
                          { "message": "\(word)" }
                        """
        case .login:
            let word = firstTime ?  "905ef89d-25a4-4255-902f-fafd4f6a9774" : "905ef89d-25a4d4f6a9774"

            json = """
                         { "auth_token": "\(word)",
                             "user": {
                                 "lastname": "Frog",
                                 "firstname": "Toxic",
                                 "login": "admin",
                                 "id": 0 }}
                        """
        case .logout:
            let word = firstTime ?  "Вы успешно вышли из приложения" : "Succes"

            json = """
                        { "message": "\(word)" }
                        """
        case  .changeUserData:
            let word = firstTime ?  "Данные изменены!" : "Succes"

            json = """
                        { "message": "\(word)" }
                        """
        case .catalog:
            let array = firstTime ? """
            [ {
                    "id": 48,
                    "description": "Мощный товар 48",
                    "category": 1,
                    "name": "Товар 48",
                    "price": 18357
                },
                {
                    "id": 50,
                    "description": "Мощный товар 50",
                    "category": 1,
                    "name": "Товар 50",
                    "price": 99241
                }]
            """
            : "[]"
            json = """
                        { "products": \(array),
                            "max_page": 1,
                            "page_number": 1 }
                        """
        case .product:
            let word = firstTime ?  "1" : "2"

            json = """
                         { "id": \(word),
                             "description": "Мощный товар 1",
                             "category": 2,
                             "name": "Товар 1",
                             "price": 6283 }
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
