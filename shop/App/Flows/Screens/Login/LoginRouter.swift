//
//  LoginRouter.swift
//  shop
//
//  Created by Ke4a on 31.10.2022.
//

import UIKit

/// Router protocol for presenter "sign in". Navigating between screens.
protocol LoginRouterInput {
    /// Open the screen with registration through the navigation controller.
    func openSignUp()
    /// Open the screen with user info.
    func openCatalog()
}

/// Router for presenter "sign in". Navigating between screens.
class LoginRouter: LoginRouterInput {
    // MARK: - Public Properties

    /// Screen controller.
    weak var controller: UIViewController?

    // MARK: - Public Methods

    func openSignUp() {
        let vc = AppModuleBuilder.signUpBuild()
        vc.modalPresentationStyle = .fullScreen
        controller?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openCatalog() {
        DispatchQueue.main.async {
            let vc = AppModuleBuilder.catalogBuild()
            vc.modalPresentationStyle = .fullScreen
            self.controller?.navigationController?.setViewControllers([vc], animated: true)
        }
    }
}
