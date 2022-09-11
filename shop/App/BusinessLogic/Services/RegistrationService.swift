//
//  RegistrationService.swift
//  shop
//
//  Created by Ke4a on 31.08.2022.
//

import Foundation

/// Registration service.
final class RegistrationService<Parser: DecoderResponseProtocol> {
    // MARK: - Private Properties
    
    private(set) var userInfo: RequestUserInfo?
    private(set) var data: Parser.Model?

    private let network: NetworkProtocol
    private let decoder: Parser

    // MARK: - Initialization

    init(_ network: NetworkProtocol, _ decoder: Parser) {
        self.network = network
        self.decoder = decoder
        
        userInfo = RequestUserInfo(login: "Somebody",
                                   password: "mypassword",
                                   firstname: "Spider" ,
                                   lastname: "Man" ,
                                   email: "some@some.ru",
                                   gender: "m",
                                   creditCard: "9872389-2424-234224-234",
                                   bio: "This is good! I think I will switch to another language")
    }

    // MARK: - Public Methods
    
    /// Fetch async data.
    /// The decoded models are written to the date property.
    func fetchAsync() {
        guard let userInfo = userInfo else { return }

        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.registration(userInfo)) {
                // Отключил пока вызывается в appDelegate, так как там не сохраняется
                // [weak self]
                result in
                
                // guard let self = self else { return }

                do {
                    switch result {
                    case .success(let data):
                        let response = try self.decoder.decode(data: data)
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
