//
//  LoginView.swift
//  shop
//
//  Created by Ke4a on 08.11.2022.
//

import UIKit

extension LoginView {
    /// Screen buttons.
    enum Button {
        /// Button sign in. Responsible for Authorization.
        case signIn
        /// Button sign up. Responsible for registration.
        case signUp
    }
}

class LoginView: UIView {
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
        label.text = AppDataScreen.signIn.logoName
        label.textColor = AppStyles.color.incomplete
        return label
    }()

    /// Field for login.
    private lazy var loginTextfield: AppTextfield = {
        let field = AppTextfield(AppDataScreen.signIn.loginPlaceholder,
                                 incompleteColor: AppStyles.color.incomplete,
                                 completeColor: AppStyles.color.complete,
                                 minChar: 5)
        field.autocorrectionType = .no
        field.returnKeyType = .next
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    /// Field for password.
    private lazy var passTextfield: AppTextfield = {
        let field = AppTextfield(AppDataScreen.signIn.passPlaceholder,
                                 incompleteColor: AppStyles.color.incomplete,
                                 completeColor: AppStyles.color.complete,
                                 minChar: 5,
                                 mode: .secure)
        field.returnKeyType = .continue
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    /// Submit button.
    private lazy var signInButton: AppButton = {
        let button = AppButton(tittle: AppDataScreen.signIn.submitButton,
                               activityIndicator: true)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()

    // MARK: - Public Properties

    /// Field Data.
    var textsFields: (login: String, pass: String)? {
        guard let login = loginTextfield.text, let pass = passTextfield.text else { return nil }
        return (login, pass)
    }

    /// The  delegate controller.
    weak var delegate: (UIViewController & UITextFieldDelegate)? {
        willSet {
            loginTextfield.delegate = newValue
            passTextfield.delegate = newValue
        }
    }

    init() {
        super.init(frame: .zero)
        addSwipeDismissKeyboard()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setting UI Methods

    /// Settings for the visual part.
    func setupUI() {
        let padding: CGFloat = AppStyles.size.padding

        backgroundColor = AppStyles.color.background

        addSubview(signUpButton)
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding * 2),
            signUpButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                   constant: -padding * 2),
            signUpButton.heightAnchor.constraint(equalToConstant: 32),
            signUpButton.widthAnchor.constraint(equalToConstant: 32)
        ])

        addSubview(loginTextfield)
        NSLayoutConstraint.activate([
            loginTextfield.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            loginTextfield.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                     constant: -padding),
            loginTextfield.heightAnchor.constraint(equalToConstant: AppStyles.size.height.textfield)
        ])

        addSubview(logoLabel)
        NSLayoutConstraint.activate([
            logoLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            logoLabel.bottomAnchor.constraint(equalTo: loginTextfield.topAnchor, constant: -(padding * 3))
        ])

        addSubview(passTextfield)
        NSLayoutConstraint.activate([
            passTextfield.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            passTextfield.topAnchor.constraint(equalTo: loginTextfield.bottomAnchor, constant: padding),
            passTextfield.leadingAnchor.constraint(equalTo: loginTextfield.leadingAnchor),
            passTextfield.trailingAnchor.constraint(equalTo: loginTextfield.trailingAnchor),
            passTextfield.heightAnchor.constraint(equalTo: loginTextfield.heightAnchor)
        ])

        addSubview(signInButton)
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalTo: passTextfield.bottomAnchor, constant: padding),
            signInButton.leadingAnchor.constraint(equalTo: passTextfield.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: passTextfield.trailingAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: AppStyles.size.height.button)
        ])

        // I'm running here because lazy variables, so as not to run at the init.
        setUITests()
    }

    // MARK: - Public Methods

    /// Shows loading indicator in button  view controller.
    /// - Parameter isLoading: Enable/disable loading indicator.
    func showLoadingButton(_ isLoading: Bool) {
        signInButton.showLoadingIndicator(isLoading)
    }

    /// Checking the minimum number of characters for the fields and starting the animation if the field are filled or all fields filled
    func checkFilledFieldsAnimation() {
        let loginIsField = loginTextfield.isFill
        let passIsField = passTextfield.isFill

        filledFieldsAnimation(filled: loginIsField && passIsField)
    }

    /// Adding an Action to a Button
    /// - Parameters:
    ///   - button: Screen button.
    ///   - action: Button action.
    func addTargetButton(button: Button, action: Selector) {
        switch button {
        case .signIn:
            signInButton.addTarget(delegate, action: action, for: .touchUpInside)
        case .signUp:
            signUpButton.addTarget(delegate, action: action, for: .touchUpInside)
        }
    }

    func nextResponder(current responder: UIView) -> Bool {
        guard let index = subviews.firstIndex(where: { $0.isFirstResponder }),
              index < subviews.endIndex - 1,
              let nextResponder = subviews[index + 1..<subviews.endIndex].first(where: { $0.canBecomeFirstResponder })
        else {
            responder.resignFirstResponder()
            return false
        }

        responder.resignFirstResponder()
        nextResponder.becomeFirstResponder()

        return true
    }

    // MARK: - Private Properties

    private func addSwipeDismissKeyboard() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboardAction))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
    }

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

    /// Set identifier for components.
    private func setUITests() {
        self.accessibilityIdentifier = "loginView"
        logoLabel.accessibilityIdentifier = "logoLabel"
        loginTextfield.accessibilityIdentifier = "loginTextfield"
        passTextfield.accessibilityIdentifier = "passTextfield"
        signInButton.accessibilityIdentifier = "signInButton"
        signUpButton.accessibilityIdentifier = "signUpButton"
    }

    // MARK: - Actions

    @objc private func dismissKeyboardAction() {
        endEditing(false)
    }
}
