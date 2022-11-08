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

        let controller = LoginViewController(presenter)

        presenter.viewInput = controller
        router.controller = controller

        return controller
    }

    /// Builds "sign up" screen + presenter + interactor + router .
    /// - Returns: Registration controller.
    static func signUpBuild() -> (UIViewController & SignUpViewInput) {
        let network = Network()
        let decoder = DecoderResponse()

        let interactor = SignUpInteractor(network, decoder)
        let router = SignUpRouter()
        let presenter = SingUpPresenter(interactor: interactor, router: router)

        let controller = SignUpViewController(presenter: presenter)

        presenter.viewInput = controller
        router.controller = controller

        return controller
    }
}
