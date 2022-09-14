//
//  ServiceFactory.swift
//  shop
//
//  Created by Ke4a on 31.08.2022.
//

import Foundation

/// Services factory.
final class ServiceFactory {
    // MARK: - Public Methods

    func makeLoginService() -> LoginService {
        let decoder = DecoderResponse()
        let network: NetworkProtocol = Network()
        return LoginService(network, decoder)
    }

    func makeLogoutService() -> LogoutService {
        let decoder = DecoderResponse()
        let network: NetworkProtocol = Network()
        return LogoutService(network, decoder)
    }
    
    func makeRegistrationService() -> RegistrationService {
        let decoder = DecoderResponse()
        let network: NetworkProtocol = Network()
        return RegistrationService(network, decoder)
    }

    func makeChangUserInfoService() -> ChangeUserInfoService {
        let decoder = DecoderResponse()
        let network: NetworkProtocol = Network()
        return ChangeUserInfoService(network, decoder)
    }

    func makeCatalogService() -> CatalogService {
        let decoder = DecoderResponse()
        let network: NetworkProtocol = Network()
        return CatalogService(network, decoder)
    }

    func makeProductService() -> ProductService {
        let decoder = DecoderResponse()
        let network: NetworkProtocol = Network()
        return ProductService(network, decoder)
    }

    func makeReviewsProductService() -> ReviewsProductService {
        let decoder = DecoderResponse()
        let network: NetworkProtocol = Network()
        return ReviewsProductService(network, decoder)
    }
}
