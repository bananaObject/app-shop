//
//  LoginService.swift
//  shop
//
//  Created by Ke4a on 31.08.2022.
//

import Foundation

/// Login service.
final class LoginService {
    typealias Model = ResponseLoginModel
    
    // MARK: - Private Properties

    private(set) var loginPass: RequestLogin?
    private(set) var data: Model?

    private let network: NetworkProtocol
    private let decoder: DecoderResponseProtocol

    // MARK: - Initialization

    init(_ network: NetworkProtocol, _ decoder: DecoderResponseProtocol) {
        self.network = network
        self.decoder = decoder
        
        loginPass = RequestLogin(login: "admin", password: "admin")
    }

    // MARK: - Public Methods
    
    /// Fetch async data.
    /// The decoded models are written to the date property.
    func fetchAsync() {
        guard let loginPass = loginPass else { return }
        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.login(loginPass)) {
                // Отключил пока вызывается в appDelegate, так как там не сохраняется
                // [weak self]
                result in

                // guard let self = self else { return }
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
