//
//  Network.swift
//  shop
//
//  Created by Ke4a on 31.08.2022.
//

import Foundation

/// Network protocol.
/// One methods  with support async/await iOS 13.
protocol NetworkProtocol {
    /// Server request.
    /// - Parameters:
    ///   - endpoint: Request address.
    ///   - completion: Сlosure with type Result.
    func fetch(_ endpoint: NetworkEndpoint, _ completion: @escaping (Result<Data, RequestError>) -> Void)

    @available(iOS 13.0.0, *)
    /// Server request iOS 13.
    /// Will throw error from on failure.
    /// - Parameter endpoint: Request address.
    /// - Returns: Response data.
    func fetch(_ endpoint: NetworkEndpoint) async throws -> Data
}

/// Network layer.
/// Implemented two methods, one with support async/await iOS 13.
final class Network: NetworkProtocol {
    // MARK: - Private Properties

    private var urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default)

    // MARK: - Public Methods
    
    func fetch(_ endpoint: NetworkEndpoint, _ completion: @escaping (Result<Data, RequestError>) -> Void) {
        // Getting data from Enum.
        var urlComponents: URLComponents = endpoint.baseURL
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.params

        guard let url: URL = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue

        urlSession.dataTask(with: request) { data, response, _ in
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.noResponse))
                return
            }

            switch response.statusCode {
            case 200...299:
                guard let data = data else {
                    return
                }
                completion(.success(data))
            default:
                completion(.failure(.unexpectedStatusCode))
            }
        }.resume()
    }

    @available(iOS 13.0.0, *)
    func fetch(_ endpoint: NetworkEndpoint) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            var urlComponents: URLComponents = endpoint.baseURL
            urlComponents.path = endpoint.path
            urlComponents.queryItems = endpoint.params

            guard let url: URL = urlComponents.url else {
                continuation.resume(throwing: RequestError.invalidURL)
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = endpoint.method.rawValue

            urlSession.dataTask(with: request) { data, response, _ in
                guard let response = response as? HTTPURLResponse else {
                    continuation.resume(throwing: RequestError.noResponse)
                    return
                }

                switch response.statusCode {
                case 200...299:
                    guard let data = data else {
                        return
                    }
                    continuation.resume(returning: data)
                default:
                    continuation.resume(throwing: RequestError.unexpectedStatusCode)
                }
            }.resume()
        }
    }
}
