//
//  LoginInteractor.swift
//  shop
//
//  Created by Ke4a on 31.08.2022.
//

import Foundation

/// Interactor protocol for presenter "sign in". Contains business logic.
protocol LoginInteractorInput {
    /// Fetch async data.
    /// The decoded models are written to the date property.
    func fetchAsync(_ data: RequestLogin)
}

/// Interactor protocol for presenter "sign in". Contains  interactor output logic.
protocol LoginInteractorOutput {
    /// Request result.
    /// - Parameter result: Result response succes/fail
    func interactorSendResultFetch(_ result: Result<ResponseLoginModel, NetworkErrorModel>)
}

/// Interactor for presenter "sign in". Contains business logic.
final class LoginInteractor: LoginInteractorInput {
    // MARK: - Public Properties

    /// Controls the display of the view.
    weak var presenter: (AnyObject & LoginInteractorOutput)?
    
    // MARK: - Private Properties

    /// Network service.
    private let network: NetworkProtocol
    /// Decoder service.
    private let decoder: DecoderResponseProtocol

    // MARK: - Initialization

    /// Interactor for presenter "sign in". Contains business logic.
    /// - Parameters:
    ///   - network: Network service.
    ///   - decoder: Decoder srevice.
    init(_ network: NetworkProtocol, _ decoder: DecoderResponseProtocol) {
        self.network = network
        self.decoder = decoder
    }

    // MARK: - Public Methods
    
    func fetchAsync(_ data: RequestLogin) {
        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.login(data)) { [weak self] result in
                guard let self = self else { return }
                do {
                    switch result {
                    case .success(let data):
                        // Decode response
                        let response = try self.decoder.decode(data: data, model: ResponseLoginModel.self)
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
