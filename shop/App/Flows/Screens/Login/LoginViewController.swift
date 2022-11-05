//
//  LoginViewController.swift
//  shop
//
//  Created by Ke4a on 27.10.2022.
//

import UIKit

/// "Sign in" screen with presenter.
class LoginViewController: UIViewController {
    // MARK: - Visual Components

    /// Button sign up.
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: AppDataScreen.image.signUp)
        button.setImage(image, for: .normal)
        button.tintColor = AppStyles.color.incomplete
        return button
    }()

    /// Logo
    private lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppStyles.font.logo
        label.text = AppDataScreen.login.logoName
        label.textColor = AppStyles.color.incomplete
        return label
    }()

    /// Field for login.
    private lazy var loginTextfield: AppTextfield = {
        let field = AppTextfield(AppDataScreen.login.loginPlaceholder,
                                 incompleteColor: AppStyles.color.incomplete,
                                 completeColor: AppStyles.color.complete,
                                 minChar: 5)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    /// Field for password.
    private lazy var passTextfield: AppTextfield = {
        let field = AppTextfield(AppDataScreen.login.passPlaceholder,
                                 incompleteColor: AppStyles.color.incomplete,
                                 completeColor: AppStyles.color.complete,
                                 minChar: 5,
                                 mode: .secure)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    /// Submit button.
    private lazy var signInButton: AppButton = {
        let button = AppButton(tittle: AppDataScreen.login.submitButton,
                               activityIndicator: true)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()

    // MARK: - Private Properties

    /// Presenter with screen control.
    private var presenter: LoginViewOutput?

    // MARK: - Initialization

    /// Presenter with screen control.
    /// - Parameter presenter: Presenter with screen control protocol
    init(_ presenter: LoginViewOutput) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addButtonAction()

        loginTextfield.delegate = self
        passTextfield.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hiding the navbar
        self.navigationController?.isNavigationBarHidden = true
    }

    // MARK: - Setting UI Methods

    /// Settings for the visual part.
    private func setupUI() {
        let padding: CGFloat = AppStyles.size.padding

        view.backgroundColor = AppStyles.color.background

        view.addSubview(signUpButton)
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding * 2),
            signUpButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                   constant: -padding * 2),
            signUpButton.heightAnchor.constraint(equalToConstant: 32),
            signUpButton.widthAnchor.constraint(equalToConstant: 32)
        ])

        view.addSubview(loginTextfield)
        NSLayoutConstraint.activate([
            loginTextfield.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            loginTextfield.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            loginTextfield.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                     constant: -padding),
            loginTextfield.heightAnchor.constraint(equalToConstant: AppStyles.size.height.textfield)
        ])

        view.addSubview(logoLabel)
        NSLayoutConstraint.activate([
            logoLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoLabel.bottomAnchor.constraint(equalTo: loginTextfield.topAnchor, constant: -(padding * 3))
        ])

        view.addSubview(passTextfield)
        NSLayoutConstraint.activate([
            passTextfield.topAnchor.constraint(equalTo: loginTextfield.bottomAnchor, constant: padding),
            passTextfield.leadingAnchor.constraint(equalTo: loginTextfield.leadingAnchor),
            passTextfield.trailingAnchor.constraint(equalTo: loginTextfield.trailingAnchor),
            passTextfield.heightAnchor.constraint(equalTo: loginTextfield.heightAnchor)
        ])

        view.addSubview(signInButton)
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalTo: passTextfield.bottomAnchor, constant: padding),
            signInButton.leadingAnchor.constraint(equalTo: passTextfield.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: passTextfield.trailingAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: AppStyles.size.height.button)
        ])
    }

    // MARK: - Private Methods

    /// Animation of the logo and button if the fields are filled or unfilled.
    /// - Parameter filled: Fields is filled.
    private func filledFieldsAnimation(filled: Bool) {
        // If the field is considered filled and the color changes with animation.
        // The color is checked so that each time the text field changes, it doesn't change to the same color.

        if filled && signInButton.isEnabled == false {
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut) {
                self.logoLabel.textColor = AppStyles.color.complete
                self.logoLabel.layer.shadowColor = UIColor.black.cgColor
                self.logoLabel.layer.shadowRadius = 1.5
                self.logoLabel.layer.shadowOpacity = 1.0
                self.logoLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
            }

            self.signInButton.setIsEnable(enable: true)
        } else if !filled && signInButton.isEnabled == true {
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut) {
                self.logoLabel.textColor = AppStyles.color.incomplete
                self.logoLabel.layer.shadowColor = .none
                self.logoLabel.layer.shadowRadius = 0
                self.logoLabel.layer.shadowOpacity = 0
                self.logoLabel.layer.shadowOffset = .zero
            }

            self.signInButton.setIsEnable(enable: false)
        }
    }

    /// Checking the minimum number of characters for the fields and starting the animation if the field are filled or all fields filled
    private func checkMinCharAnimation() {
        let loginIsField = loginTextfield.checkMinCharAnimation()
        let passIsField = passTextfield.checkMinCharAnimation()

        filledFieldsAnimation(filled: loginIsField && passIsField)
    }

    /// Adds action for buttons.
    private func addButtonAction() {
        signUpButton.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(signInButtonAction), for: .touchUpInside)
    }

    // MARK: - Actions

    /// Action button sign in.
    /// - Parameter sender: Button sign in.
    @objc private func signInButtonAction(_ sender: AppButton) {
        sender.clickAnimation()

        guard let login = loginTextfield.text, let pass = passTextfield.text else { return }
        self.presenter?.viewSignIn(login, pass)
    }

    /// Action button sign up.
    /// - Parameter sender: Button sign up.
    @objc private func signUpButtonAction(_ sender: UIButton) {
        self.presenter?.viewSignUp()
    }
}

// MARK: - LoginViewInput

extension LoginViewController: LoginViewInput {
    func showError(_ error: String) {
        DispatchQueue.main.async {
            let alertContoller = UIAlertController(title: "Error" ,
                                                   message: error,
                                                   preferredStyle: .alert)
            alertContoller.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
            self.present(alertContoller, animated: true)
        }
    }

    func showLoadingButton(_ isLoading: Bool) {
        signInButton.showLoadingIndicator(isLoading)
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkMinCharAnimation()
    }
}
