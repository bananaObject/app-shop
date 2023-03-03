//
//  LogoutService.swift
//  shop
//
//  Created by Ke4a on 05.09.2022.
//

import Foundation

/// Logout service.
final class LogoutService {
    typealias Model = ResponseMessageModel
    
    // MARK: - Private Properties

    private(set) var token: String?
    private(set) var data: Model?

    private let network: NetworkProtocol
    private let decoder: DecoderResponseProtocol

    // MARK: - Initialization

    init(_ network: NetworkProtocol, _ decoder: DecoderResponseProtocol) {
        self.network = network
        self.decoder = decoder

        token = "905ef89d-25a4-4255-902f-fafd4f6a9774"
    }

    // MARK: - Public Methods
    
    /// Fetch async data.
    /// The decoded models are written to the date property.
    func fetchAsync() {
        // guard let token = token else { return }

        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.logout) { [weak self] result in
                guard let self = self else { return }
                
                do {
                    switch result {
                    case .success(let data):
                        let response = try self.decoder.decode(data: data, model: Model.self)
                        self.data = response
                    case .failure(let error):
                        switch error {
                        case .clientError(let status, let data):
                            let decodeError = try self.decoder.decodeError(data: data)
                            print("status: \(status) \n\(decodeError)")
                        default:
                            throw error
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}
