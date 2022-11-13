//
//  SignUpRouter.swift
//  shop
//
//  Created by Ke4a on 01.11.2022.
//

import UIKit

/// Router protocol for presenter "sign up". Navigating between screens.
protocol SignUpRouterInput {
    /// Exit current screen.
    func popViewcontroller()
}

/// Router for presenter "sign up". Navigating between screens.
class SignUpRouter: SignUpRouterInput {
    // MARK: - Public Properties
    
    /// Screen controller.
    weak var controller: UIViewController?

    // MARK: - Public Methods

    func popViewcontroller() {
        if  let navController = self.controller?.navigationController {
            navController.popViewController(animated: true)
        } else {
            self.controller?.dismiss(animated: true)
        }
    }
}
