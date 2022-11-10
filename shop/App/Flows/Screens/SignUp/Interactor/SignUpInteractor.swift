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
    func fetchAsync(_ data: RequestUserInfo)
}

/// Interactor protocol for presenter "sign up". Contains  interactor output logic.
protocol SignUpInteractorOutput {
    /// Request result.
    /// - Parameter result: Result response succes/fail
    func interactorSendResultFetch(_ result: Result<ResponseMessageModel, NetworkErrorModel>)
}

class SignUpInteractor: SignUpInteractorInput {
    // MARK: - Public Properties

    /// Controls the display of the view.
    weak var presenter: (AnyObject & SignUpInteractorOutput)?

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

    func fetchAsync(_ data: RequestUserInfo) {
        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.registration(data)) { [weak self] result in
                guard let self = self else { return }

                do {
                    switch result {
                    case .success(let data):
                        // Decode response
                        let response = try self.decoder.decode(data: data, model: ResponseMessageModel.self)
                        self.presenter?.interactorSendResultFetch(.success(response))
                    case .failure(let error):
                        switch error {
                        case .clientError(_, let data):
                            let decodeError = try self.decoder.decodeError(data: data)
                            self.presenter?.interactorSendResultFetch(.failure(decodeError))
                        default:
                            self.presenter?.interactorSendResultFetch(.failure(
                                .init(error: true, reason: error.customMessage)
                            ))
                        }
                    }
                } catch {
                    self.presenter?.interactorSendResultFetch(.failure(
                        .init(error: true, reason: "App error")
                    ))
                }
            }
        }
    }
}
