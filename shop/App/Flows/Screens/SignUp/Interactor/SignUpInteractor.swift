//
//  SignUpInteractor.swift
//  shop
//
//  Created by Ke4a on 01.11.2022.
//

import Foundation

/// Interactor protocol for presenter "sign up". Contains business logic.
protocol SignUpInteractorInput {
    /// Fetch async data.
    /// The decoded models are written to the date property.
    func fetchAsync(_ data: RequestUserInfo,
                    completion: @escaping (Result<ResponseMessageModel, NetworkErrorModel>
                    ) -> Void)
}

class SignUpInteractor: SignUpInteractorInput {
    // MARK: - Private Properties

    /// Network service.
    private let network: NetworkProtocol
    /// Decoder service.
    private let decoder: DecoderResponseProtocol

    // MARK: - Initialization

    /// Interactor for presenter "sign up". Contains business logic.
    /// - Parameters:
    ///   - network: Network service.
    ///   - decoder: Decoder srevice.
    init(_ network: NetworkProtocol, _ decoder: DecoderResponseProtocol) {
        self.network = network
        self.decoder = decoder
    }

    func fetchAsync(_ data: RequestUserInfo,
                    completion: @escaping (Result<ResponseMessageModel, NetworkErrorModel>
                    ) -> Void) {

        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.registration(data)) { [weak self] result in
                guard let self = self else { return }

                do {
                    switch result {
                    case .success(let data):
                        // Decode response
                        let response = try self.decoder.decode(data: data, model: ResponseMessageModel.self)
                        completion(.success(response))
                    case .failure(let error):
                        switch error {
                        case .clientError(_, let data):
                            let decodeError = try self.decoder.decodeError(data: data)
                            completion(.failure(decodeError))
                        default:
                            completion(.failure(
                                .init(error: true, reason: error.customMessage)
                            ))
                        }
                    }
                } catch {
                    completion(.failure(
                        .init(error: true, reason: "App error")
                    ))
                }
            }
        }
    }
}
