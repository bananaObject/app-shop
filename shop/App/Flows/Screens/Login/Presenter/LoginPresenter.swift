//
//  LoginPresenter.swift
//  shop
//
//  Created by Ke4a on 31.10.2022.
//

import UIKit

protocol LoginViewInput {
    func showError(_ error: String)
}

protocol LoginViewOutput {
    func viewSignIn(_ login: String, _ pass: String)
    func viewSignUp()
}

class LoginPresenter {
    weak var viewInput: (UIViewController & LoginViewInput)?

    private let interactor: LoginInteractorInput
    private let router: LoginRouterInput

    init(interactor: LoginInteractorInput, router: LoginRouterInput) {
        self.interactor = interactor
        self.router = router
    }

    func fetchReques(_ login: String, pass: String) {
        let requestData = RequestLogin(login: login, password: pass)

        interactor.fetchAsync(requestData) { result in
            switch result {
            case .success(let success):
                print(success)
                self.router.openUserInfo()
            case .failure(let failure):
                self.viewInput?.showError(failure.reason ?? "error")
            }
        }
    }
}

extension LoginPresenter: LoginViewOutput {
    func viewSignUp() {
        self.router.openSignUp()
    }

    func viewSignIn(_ login: String, _ pass: String) {
        fetchReques(login, pass: pass)
    }
}
