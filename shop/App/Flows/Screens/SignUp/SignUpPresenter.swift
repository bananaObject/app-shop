//
//  SignUpPresenter.swift
//  shop
//
//  Created by Ke4a on 01.11.2022.
//

import UIKit

/// "Sign up" presenter. Manages user interaction and view.
class SignUpPresenter {
    // MARK: - Public Properties

    /// Input view controller. For manages.
    weak var viewInput: (UIViewController & SignUpViewControllerInput)?

    // MARK: - Private Properties
    
    /// Interactor. Contains business logic.
    private let interactor: SignUpInteractorInput
    /// Router. Navigating between screens..
    private let router: SignUpRouterInput
    /// Screen components and settings for them.
    private lazy var componentsData = AppDataScreen.signUp.components

    // MARK: - Initialization
    
    /// "Sign up" presenter. Manages user interaction and view.
    /// - Parameters:
    ///   - interactor: Contains business logic.
    ///   - router: Navigating between screens.
    init(interactor: SignUpInteractorInput, router: SignUpRouterInput) {
        self.interactor = interactor
        self.router = router
    }

    // MARK: - Private Methods

    /// Fetch requst sign up.
    /// - Parameters:
    ///   - data: Request user info data.
    private func fetchRequest(_ data: RequestUserInfo) {
        viewInput?.showLoadingButton(true)
        interactor.fetchAsync(data)
    }

    /// Assembly of the request structure.
    /// - Returns: Data user info.
    private func getRequestUserInfo() -> RequestUserInfo {
        var request = RequestUserInfo()

        components.enumerated().forEach { index, component in
            guard let text = self.viewInput?.fieldsText[index] else {
                return
            }

            switch component {
            case .login:
                request.login = text
            case .password:
                request.password = text
            case .firstName:
                request.firstname = text
            case .lastname:
                request.lastname = text
            case .email:
                request.email = text
            case .gender:
                request.gender = text
            case .creditCard:
                request.creditCard = text
            case .bio:
                request.bio = text
            case .submitButton:
                break
            }
        }

        return request
    }
}

// MARK: - SignUpViewControllerOutput

extension SignUpPresenter: SignUpViewControllerOutput {
    var components: [AppDataScreen.signUp.Component] {
        self.componentsData
    }

    func popViewController() {
        router.popViewcontroller()
    }

    func viewSignUp() {
        let request = getRequestUserInfo()
        fetchRequest(request)
    }
}

// MARK: - SignUpInteractorOutput

extension SignUpPresenter: SignUpInteractorOutput {
    func interactorSendResultFetch(_ result: Result<ResponseMessageModel, NetworkErrorModel>) {
        DispatchQueue.main.async {
            self.viewInput?.showLoadingButton(false)
        }
        switch result {
        case .success(let success):
            self.viewInput?.showAllert("Succes", success.message, false)
        case .failure(let failure):
            self.viewInput?.showAllert("Error", failure.reason ?? "unknown error", true)
        }
    }
}
