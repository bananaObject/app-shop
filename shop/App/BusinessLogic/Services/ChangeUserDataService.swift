//
//  ChangeUserDataService.swift
//  shop
//
//  Created by Ke4a on 05.09.2022.
//

import Foundation

/// Change user data service.
class ChangeUserDataService<Parser: ResponseParserProtocol> {
    // MARK: - Public Properties

    var requestData: RequestUserData?
    var data: Parser.Model?

    // MARK: - Private Properties

    private let network: NetworkProtocol
    private let decoder: Parser

    // MARK: - Initialization

    init(_ network: NetworkProtocol, _ decoder: Parser) {
        self.network = network
        self.decoder = decoder

        requestData = RequestUserData(id: "123",
                                      username: "Somebody",
                                      password: "mypassword",
                                      email: "some@some.ru",
                                      gender: "m",
                                      creditCard: "9872389-2424-234224-234",
                                      bio: "This is good! I think I will switch to another language")
    }

    // MARK: - Public Methods

    /// Fetch async data.
    /// The decoded models are written to the date property.
    func fetchAsync() {
        guard let requestData = requestData else { return }

        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.changeUserData(requestData)) {
                // Отключил пока вызывается в appDelegate, так как там не сохраняется
                // [weak self]
                result in

                // guard let self = self else { return }

                switch result {
                case .success(let data):
                    guard let response = try? self.decoder.decode(data: data) else { return }
                    self.data = response
                    print(self.data)
                case .failure:
                    break
                }
            }
        }
    }
}
