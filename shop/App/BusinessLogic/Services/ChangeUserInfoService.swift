//
//  ChangeUserInfoService.swift
//  shop
//
//  Created by Ke4a on 05.09.2022.
//

import Foundation

/// Change user data service.
final class ChangeUserInfoService {
    typealias Model = ResponseMessageModel

    // MARK: - Private Properties

    private(set) var userInfo: RequestUserInfo?
    private(set) var data: Model?

    private let network: NetworkProtocol
    private let decoder: DecoderResponseProtocol

    // MARK: - Initialization
    
    init(_ network: NetworkProtocol, _ decoder: DecoderResponseProtocol) {
        self.network = network
        self.decoder = decoder

        userInfo = RequestUserInfo(login: "Somebody",
                                   password: "mypassword",
                                   firstname: "1",
                                   lastname: "1",
                                   email: "some@some.ru",
                                   gender: "m",
                                   creditCard: "9872389-2424-234224-234",
                                   bio: "This is good! I think I will switch to another language")
    }

    // MARK: - Public Methods

    /// Fetch async data.
    /// The decoded models are written to the date property.
    func fetchChangeInfoAsync() {
        guard let userInfo = userInfo else { return }

        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.changeUserData(userInfo)) { [weak self] result in
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

    /// Fetch async data.
    /// The decoded models are written to the date property.
    func fetchGetInfoAsync() {
        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.getUserInfo("Token")) { [weak self] result in
                guard let self = self else { return }

                do {
                    switch result {
                    case .success(let data):
                        let response = try self.decoder.decode(data: data, model: ResponseUserInfo.self)
                        print(response)
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
