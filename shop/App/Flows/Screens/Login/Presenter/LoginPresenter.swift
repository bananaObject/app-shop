//
//  LoginPresenter.swift
//  shop
//
//  Created by Ke4a on 31.10.2022.
//

import UIKit

/// "Sign in" presenter. Manages user interaction and view.
class LoginPresenter {
    // MARK: - Public Properties

    /// Input view controller. For manages.
    weak var viewInput: (UIViewController & LoginViewControllerInput)?

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
        interactor.fetchAsync(requestData)
    }
}

// MARK: - LoginViewOutput

extension LoginPresenter: LoginViewControllerOutput {
    func viewSignUp() {
        self.router.openSignUp()
    }

    func viewSignIn(_ login: String, _ pass: String) {
        fetchRequest(login: login, pass: pass)
    }
}

// MARK: - LoginInteractorOutput

extension LoginPresenter: LoginInteractorOutput {
    func interactorSendResultFetch(_ result: Result<ResponseLoginModel, NetworkErrorModel>) {
        DispatchQueue.main.async {
            self.viewInput?.showLoadingButton(false)
        }
        switch result {
        case .success:
            self.router.openCatalog()
        case .failure(let failure):
            self.viewInput?.showError(failure.reason ?? "error")
        }
    }
}
