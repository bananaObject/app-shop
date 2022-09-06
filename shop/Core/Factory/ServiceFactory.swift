//
//  ServiceFactory.swift
//  shop
//
//  Created by Ke4a on 31.08.2022.
//

import Foundation

/// Services factory.
class ServiceFactory {
    // MARK: - Public Methods
    
    func makeRegistrationService() -> RegistrationService<ResponseParser<ResponseRegistrationModel>> {
        let decoder = ResponseParser<ResponseRegistrationModel>()
        let network: NetworkProtocol = Network()
        return RegistrationService(network, decoder)
    }

    func makeLoginService() -> LoginService<ResponseParser<ResponseLoginModel>> {
        let decoder = ResponseParser<ResponseLoginModel>()
        let network: NetworkProtocol = Network()
        return LoginService(network, decoder)
    }

    func makeLogoutService() -> LogoutService<ResponseParser<ResponseResultModel>> {
        let decoder = ResponseParser<ResponseResultModel>()
        let network: NetworkProtocol = Network()
        return LogoutService(network, decoder)
    }

    func makeChangUserDataService()
    -> ChangeUserDataService<ResponseParser<ResponseResultModel>> {
        let decoder = ResponseParser<ResponseResultModel>()
        let network: NetworkProtocol = Network()
        return ChangeUserDataService(network, decoder)
    }
}
