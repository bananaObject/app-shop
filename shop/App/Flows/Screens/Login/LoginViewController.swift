//
//  LoginViewController.swift
//  shop
//
//  Created by Ke4a on 27.10.2022.
//

import UIKit

/// View controller "Sign in"  input protocol.
protocol LoginViewControllerInput {
    /// Shows alert error in view controller.
    /// - Parameter error: Error message.
    func showError(_ error: String)
    /// Shows loading indicator in button  view controller.
    /// - Parameter isLoading: Enable/disable loading indicator.
    func showLoadingButton(_ isLoading: Bool)
}

/// View controller "Sign in"  output protocol.
protocol LoginViewControllerOutput {
    /// View controller requested a "sign in".
    /// - Parameters:
    ///   - login: Login user.
    ///   - pass: Password user.
    func viewSignIn(_ login: String, _ pass: String)
    /// View controller requested a "sign up".
    func viewSignUp()
}

/// "Sign in" screen with presenter.
class LoginViewController: UIViewController {
    // MARK: - Visual Components
    
    /// Screen view.
    private var loginView: LoginView {
        // I do not like force unwrap, so i wrote such a thing.
        // I know that there will never be an error, but in order not to write force unwrap, i write like this.
        guard let view = self.view as? LoginView else {
            let vc = LoginView()
            self.view = vc
            return vc
        }

        return view
    }

    // MARK: - Private Properties

    /// Presenter with screen control.
    private var presenter: LoginViewControllerOutput?

    // MARK: - Initialization

    /// Presenter with screen control.
    /// - Parameter presenter: Presenter with screen control protocol
    init(_ presenter: LoginViewControllerOutput) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        // Change root view
        self.view = LoginView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // FIXME: - Автоматически залогиниться. (для тестов)
        
        presenter?.viewSignIn("admin", "admin")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hiding the navbar
        self.navigationController?.isNavigationBarHidden = true
    }

    /// Settings for the view.
    private func setupUI() {
        loginView.delegate = self
        loginView.setupUI()
        loginView.addTargetButton(button: .signUp, action: #selector(signUpButtonAction))
        loginView.addTargetButton(button: .signIn, action: #selector(signInButtonAction))
    }

    // MARK: - Actions

    /// Action button sign in.
    /// - Parameter sender: Button sign in.
    @objc private func signInButtonAction(_ sender: AppButton) {
        sender.clickAnimation()

        // Getting field data
        guard let (login, pass) = loginView.textsFields else { return }
        self.presenter?.viewSignIn(login, pass)
    }

    /// Action button sign up.
    /// - Parameter sender: Button sign up.
    @objc private func signUpButtonAction(_ sender: UIButton) {
        self.presenter?.viewSignUp()
    }
}

// MARK: - LoginViewInput

extension LoginViewController: LoginViewControllerInput {
    func showError(_ error: String) {
        DispatchQueue.main.async {
            let alertContoller = UIAlertController(title: "Error" ,
                                                   message: error,
                                                   preferredStyle: .alert)
            alertContoller.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alertContoller, animated: true)
        }
    }

    func showLoadingButton(_ isLoading: Bool) {
        loginView.showLoadingButton(isLoading)
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let field = textField as? AppTextfield else { return }
        
        field.checkMinCharAnimation()
        loginView.checkFilledFieldsAnimation()
    }
}
