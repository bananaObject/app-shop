//
//  LoginViewController.swift
//  shop
//
//  Created by Ke4a on 27.10.2022.
//

import UIKit

class LoginViewController: UIViewController {
    // MARK: - Visual Components

    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: AppStyles.image.signUp)
        button.setImage(image, for: .normal)
        button.tintColor = AppStyles.color.incomplete
        return button
    }()

    private lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .monospacedDigitSystemFont(ofSize: 44, weight: .thin)
        label.text = "SHOP"
        label.textColor = AppStyles.color.incomplete
        return label
    }()

    private lazy var loginTextfield: AppTextfield = {
        let field = AppTextfield("Login",
                                 defaultColor: AppStyles.color.incomplete,
                                 completeColor: AppStyles.color.complete)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private lazy var passTextfield: AppTextfield = {
        let field = AppTextfield("Password", secureEnable: true,
                                 defaultColor: AppStyles.color.incomplete,
                                 completeColor: AppStyles.color.complete)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private lazy var signInButton: AppButton = {
        let button = AppButton(text: "Sign in")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()

    private var presenter: LoginViewOutput?

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

    // MARK: - Setting UI Methods

    private func setupUI() {
        let padding: CGFloat = 8
        view.backgroundColor = AppStyles.color.background

        view.addSubview(signUpButton)
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding * 2),
            signUpButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                   constant: -padding * 2),
            signUpButton.heightAnchor.constraint(equalToConstant: 32),
            signUpButton.widthAnchor.constraint(equalToConstant: 32)
        ])

        view.addSubview(logoLabel)
        NSLayoutConstraint.activate([
            logoLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -100)
        ])

        view.addSubview(loginTextfield)
        NSLayoutConstraint.activate([
            loginTextfield.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 24),
            loginTextfield.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            loginTextfield.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                     constant: -padding),
            loginTextfield.heightAnchor.constraint(equalToConstant: AppStyles.frame.height.textfield)
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
            signInButton.heightAnchor.constraint(equalTo: passTextfield.heightAnchor, multiplier: 1.2)
        ])
    }

    // MARK: - Private Methods

    private func clickButtonAnimation(_ button: UIButton) {
        if let button = button as? AppButton {
            button.clickAnimation()
        } else {
            UIView.animate(withDuration: 0.20, delay: 0, options: [.autoreverse, .curveEaseInOut]) {
                button.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            } completion: { _ in
                button.transform = CGAffineTransform.identity
            }
        }
    }

    /// Full field animation.
    private func completeFieldsAnimation() {
        let completeColor = UIColor.gray
        let defualtColor = UIColor.lightGray

        guard let login = loginTextfield.text?.count, let pass = passTextfield.text?.count else { return }

        // If the field contains more than 5, the field is considered filled and I change the color with animation.
        // The color is checked so that for each change in the textfield, it will not be changed to the same color.

        if login >= 5 && loginTextfield.textColor == defualtColor {
            loginTextfield.animationComplete(true)
        } else if login < 5 && loginTextfield.textColor != defualtColor {
            loginTextfield.animationComplete(false)
        }

        if pass >= 5 && passTextfield.textColor == defualtColor {
            passTextfield.animationComplete(true)
        } else if pass < 5 && passTextfield.textColor != defualtColor {
            passTextfield.animationComplete(false)
        }

        if login >= 5 && pass >= 5 && signInButton.isEnabled == false {
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut) {
                self.logoLabel.textColor = completeColor
                self.logoLabel.layer.shadowColor = UIColor.black.cgColor
                self.logoLabel.layer.shadowRadius = 1.5
                self.logoLabel.layer.shadowOpacity = 1.0
                self.logoLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
            }

            self.signInButton.buttonIsEnable(enable: true)
        } else if (login < 5 || pass < 5) && signInButton.isEnabled == true {
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut) {
                self.logoLabel.textColor = defualtColor
                self.logoLabel.layer.shadowColor = .none
                self.logoLabel.layer.shadowRadius = 0
                self.logoLabel.layer.shadowOpacity = 0
                self.logoLabel.layer.shadowOffset = .zero
            }

            self.signInButton.buttonIsEnable(enable: false)
        }
    }

    private func addButtonAction() {
        signUpButton.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(signInButtonAction), for: .touchUpInside)
    }

    // MARK: - Actions
    
    @objc private func signInButtonAction(_ sender: UIButton) {
        clickButtonAnimation(sender)

        guard let login = loginTextfield.text, let pass = passTextfield.text else { return }
        self.presenter?.viewSignIn(login, pass)
    }

    @objc private func signUpButtonAction(_ sender: UIButton) {
        clickButtonAnimation(sender)
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
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        completeFieldsAnimation()
    }
}
