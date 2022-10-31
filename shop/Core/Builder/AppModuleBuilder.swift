//
//  AppModuleBuilder.swift
//  shop
//
//  Created by Ke4a on 31.10.2022.
//

import UIKit

/// Builder controller.
enum AppModuleBuilder {
    // MARK: - Static Methods
    
    static func loginBuild() -> (UIViewController & LoginViewInput) {
        let network = Network()
        let decoder = DecoderResponse()

        let interactor = LoginInteractor(network, decoder)
        let router = LoginRouter()
        let presenter = LoginPresenter(interactor: interactor, router: router)

        let controller = LoginViewController(presenter)

        presenter.viewInput = controller
        router.controller = controller

        return controller
    }
}
