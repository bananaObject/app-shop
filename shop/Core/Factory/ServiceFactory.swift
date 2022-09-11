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

    func makeLoginService() -> LoginService<DecoderResponse<ResponseLoginModel>> {
        let decoder = DecoderResponse<ResponseLoginModel>()
        let network: NetworkProtocol = Network()
        return LoginService(network, decoder)
    }

    func makeLogoutService() -> LogoutService<DecoderResponse<ResponseMessageModel>> {
        let decoder = DecoderResponse<ResponseMessageModel>()
        let network: NetworkProtocol = Network()
        return LogoutService(network, decoder)
    }
    
    func makeRegistrationService() -> RegistrationService<DecoderResponse<ResponseMessageModel>> {
        let decoder = DecoderResponse<ResponseMessageModel>()
        let network: NetworkProtocol = Network()
        return RegistrationService(network, decoder)
    }

    func makeChangUserInfoService()
    -> ChangeUserInfoService<DecoderResponse<ResponseMessageModel>> {
        let decoder = DecoderResponse<ResponseMessageModel>()
        let network: NetworkProtocol = Network()
        return ChangeUserInfoService(network, decoder)
    }

    func makeCatalogService() -> CatalogService<DecoderResponse<ResponseCatalogModel>> {
        let decoder = DecoderResponse<ResponseCatalogModel>()
        let network: NetworkProtocol = Network()
        return CatalogService(network, decoder)
    }

    func makeProductService() -> ProductService<DecoderResponse<ResponseProductModel>> {
        let decoder = DecoderResponse<ResponseProductModel>()
        let network: NetworkProtocol = Network()
        return ProductService(network, decoder)
    }
}
