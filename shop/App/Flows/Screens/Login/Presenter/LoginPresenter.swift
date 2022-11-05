//
//  LoginPresenter.swift
//  shop
//
//  Created by Ke4a on 31.10.2022.
//

import UIKit

/// View controller "Sign in"  input protocol.
protocol LoginViewInput {
    /// Shows alert error in view controller.
    /// - Parameter error: Error message.
    func showError(_ error: String)
    /// Shows loading indicator in button  view controller.
    /// - Parameter isLoading: Enable/disable loading indicator.
    func showLoadingButton(_ isLoading: Bool)
}

/// View controller "Sign in"  output protocol.
protocol LoginViewOutput {
    /// View controller requested a "sign in".
    /// - Parameters:
    ///   - login: Login user.
    ///   - pass: Password user.
    func viewSignIn(_ login: String, _ pass: String)
    /// View controller requested a "sign up".
    func viewSignUp()
}

/// "Sign in" presenter. Manages user interaction and view.
class LoginPresenter {
    // MARK: - Public Properties

    /// Input view controller. For manages.
    weak var viewInput: (UIViewController & LoginViewInput)?

    // MARK: - Private Properties

    /// Interactor. Contains business logic.
    private let interactor: LoginInteractorInput
    /// Router. Navigating between screens..
    private let router: LoginRouterInput

    // MARK: - Initialization

    /// "Sign in" presenter. Manages user interaction and view.
    /// - Parameters:
    ///   - interactor: Contains business logic.
    ///   - router: Navigating between screens.
    init(interactor: LoginInteractorInput, router: LoginRouterInput) {
        self.interactor = interactor
        self.router = router
    }

    // MARK: - Private Methods

    /// Fetch requst sign in.
    /// - Parameters:
    ///   - login: Login user.
    ///   - pass: Password user.
    private func fetchRequest(login: String, pass: String) {
        let requestData = RequestLogin(login: login, password: pass)

        viewInput?.showLoadingButton(true)
        interactor.fetchAsync(requestData) { result in
            DispatchQueue.main.async {
                self.viewInput?.showLoadingButton(false)
            }
            switch result {
            case .success(let success):
                self.router.openUserInfo()
            case .failure(let failure):
                self.viewInput?.showError(failure.reason ?? "error")
            }
        }
    }
}

// MARK: - LoginViewOutput

extension LoginPresenter: LoginViewOutput {
    func viewSignUp() {
        self.router.openSignUp()
    }

    func viewSignIn(_ login: String, _ pass: String) {
        fetchRequest(login: login, pass: pass)
    }
}
