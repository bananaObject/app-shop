//
//  AppModuleBuilder.swift
//  shop
//
//  Created by Ke4a on 31.10.2022.
//

import UIKit

/// Builder controllers.
enum AppModuleBuilder {
    // MARK: - Static Methods

    /// Builds "sign in" screen + presenter + interactor + router .
    /// - Returns: Login controller.
    static func loginBuild() -> (UIViewController & LoginViewControllerInput) {
        let network = Network()
        let decoder = DecoderResponse()

        let interactor = LoginInteractor(network, decoder)
        let router = LoginRouter()
        let presenter = LoginPresenter(interactor: interactor, router: router)
        interactor.presenter = presenter

        let controller = LoginViewController(presenter)

        presenter.viewInput = controller
        router.controller = controller

        return controller
    }

    /// Builds "sign up" screen + presenter + interactor + router .
    /// - Returns: Registration controller.
    static func signUpBuild() -> (UIViewController & SignUpViewControllerInput) {
        let network = Network()
        let decoder = DecoderResponse()

        let interactor = SignUpInteractor(network, decoder)
        let router = SignUpRouter()
        let presenter = SignUpPresenter(interactor: interactor, router: router)
        interactor.presenter = presenter
        
        let controller = SignUpViewController(presenter: presenter)

        presenter.viewInput = controller
        router.controller = controller

        return controller
    }

    /// Builds "catalog" screen + presenter + interactor + router .
    /// - Returns: Catalog products controller.
    static func catalogBuild() -> (UIViewController & CatalogViewControllerInput) {
        let network = Network()
        let decoder = DecoderResponse()

        let interactor = CatalogInteractor(network: network, decoder: decoder)
        let router = CatalogRouter()
        let presenter = CatalogPresenter(interactor: interactor, router: router)
        interactor.presenter = presenter

        let controller = CatalogViewController(presenter: presenter)

        presenter.viewInput = controller
        router.controller = controller

        return controller
    }

    /// Builds "Product info" screen + presenter + interactor + router .
    /// - Returns: Product info controller.
    /// - Parameters:
    ///   - idProduct: Product id.
    static func productInfoBuild(_ idProduct: Int) -> (UIViewController & ProductInfoViewControllerInput) {
        let network = Network()
        let decoder = DecoderResponse()

        let interactor = ProductInfoInteractor(network: network, decoder: decoder)
        let router = ProductInfoRouter()
        let presenter = ProductInfoPresenter(interactor: interactor, router: router, product: idProduct)
        interactor.presenter = presenter

        let controller = ProductInfoViewController(presenter: presenter)

        presenter.viewInput = controller
        router.controller = controller

        return controller
    }
}
