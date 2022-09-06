//
//  LoginService.swift
//  shop
//
//  Created by Ke4a on 31.08.2022.
//

import Foundation

/// Login service.
class LoginService<Parser: ResponseParserProtocol> {
    // MARK: - Public Properties

    var requestData: RequestLoginData?
    var data: Parser.Model?

    // MARK: - Private Properties

    private let network: NetworkProtocol
    private let decoder: Parser

    // MARK: - Initialization

    init(_ network: NetworkProtocol, _ decoder: Parser) {
        self.network = network
        self.decoder = decoder
        
        requestData = RequestLoginData(username: "Somebody", password: "mypassword")
    }

    // MARK: - Public Methods
    
    /// Fetch async data.
    /// The decoded models are written to the date property.
    func fetchAsync() {
        guard let requestData = requestData else { return }
        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.login(requestData)) {
                // Отключил пока вызывается в appDelegate, так как там не сохраняется
                // [weak self]
                result in

                // guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    do {
                        let response = try self.decoder.decode(data: data)
                        self.data = response
                        print(self.data)
                    } catch {
                        print(error)
                    }

                case .failure:
                    break
                }
            }
        }
    }
}
