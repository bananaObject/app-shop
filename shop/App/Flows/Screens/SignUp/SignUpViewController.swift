//
//  SignUpViewController.swift
//  shop
//
//  Created by Ke4a on 01.11.2022.
//

import UIKit

/// View controller "Sign up"  input protocol.
protocol SignUpViewControllerInput {
    /// Array of texts  of the screen fields.
    var fieldsText: [String?] { get }

    /// Shows alert in view controller.
    /// - Parameter tittle: Tittle.
    /// - Parameter message: Message.
    /// - Parameter error: Is error.
    func showAllert(_ tittle: String, _ message: String, _ error: Bool)

    /// Shows loading indicator in button  view controller.
    /// - Parameter isLoading: Enable/disable loading indicator.
    func showLoadingButton(_ isLoading: Bool)
}

/// View controller "Sign in"  output protocol.
protocol SignUpViewControllerOutput {
    /// An array of information about the components that the screen is built from.
    var components: [AppDataScreen.signUp.Component] { get }

    /// View controller requested a "sign up".
    /// - Parameter data: Request user info data.
    func viewSignUp()
    /// View controller requested a exit controller.
    func popViewController()
}

/// "Sign Up" screen with presenter.
class SignUpViewController: UIViewController {
    // MARK: - Visual Components
    
    /// Screen view.
    private var registrationView: SignUpView {
        // I do not like force unwrap, so i wrote such a thing.
        // I know that there will never be an error, but in order not to write force unwrap, i write like this.
        guard let view = self.view as? SignUpView else {
            let vc = SignUpView()
            self.view = vc
            return vc
        }

        return view
    }

    // MARK: - Private Properties
    
    /// Presenter with screen control.
    private var presenter: SignUpViewControllerOutput?

    // MARK: - Initialization

    /// Presenter with screen control.
    /// - Parameter presenter: Presenter with screen control protocol
    init(presenter: SignUpViewControllerOutput) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Deinitialization

    deinit {
        // Remove observer NotificationCenter.
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        // Сhange the root view
        self.view = SignUpView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavController()
        setupUI()
        addNotificationObserverKeyboard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    // MARK: - Setting UI Methods

    /// Settings for the view.
    private func setupUI() {
        registrationView.delegate = self
        registrationView.setupUI()
        registrationView.addComponentsStackview(components: presenter?.components)
        registrationView.addTargetSubmitButton(#selector(submitAction))
    }

    /// Settings navbar controller.
    private func setupNavController() {
        navigationItem.title = AppDataScreen.signUp.tittleNav

        navigationController?.navigationBar.tintColor = AppStyles.color.complete
        navigationController?.navigationBar.backgroundColor = AppStyles.color.background

        // Changes the color of the navbar title
        let textAttributes = [NSAttributedString.Key.foregroundColor: AppStyles.color.complete]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }

    /// Adding a keyboard watcher to resize the view.
    private func addNotificationObserverKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    /// Called when the keyboard is running.
    /// - Parameter notification: Notification.
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardValue = notification
            .userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        let contentInsets = UIEdgeInsets(top: 0,
                                         left: 0,
                                         bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom,
                                         right: 0)
        registrationView.setSize(contentInsets: contentInsets)
        registrationView.scrollToActiveFrame()
    }

    /// Called when the keyboard is hide.
    /// - Parameter notification: Notification
    @objc private func keyboardWillHide(notification: NSNotification) {
        let contentInsets: UIEdgeInsets = .zero
        
        self.registrationView.setSize(contentInsets: contentInsets)
    }

    // MARK: - Action

    /// Action button submit.
    /// - Parameter sender: Button sign in.
    @objc private func submitAction() {
        presenter?.viewSignUp()
    }
}

// MARK: - SignUpViewControllerInput

extension SignUpViewController: SignUpViewControllerInput {
    var fieldsText: [String?] {
        registrationView.fieldsText
    }

    func showAllert(_ tittle: String, _ message: String, _ error: Bool) {
        DispatchQueue.main.async {
            let alertContoller = UIAlertController(title: tittle,
                                                   message: message,
                                                   preferredStyle: .alert)

            let action = UIAlertAction(title: "Close",
                                       style: error ? .destructive : .default
            ) { _ in
                guard !error else { return }

                self.presenter?.popViewController()
            }

            alertContoller.addAction(action)
            self.present(alertContoller, animated: true)
        }
    }

    func showLoadingButton(_ isLoading: Bool) {
        registrationView.showLoadingButton(isLoading)
    }
}

// MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Save the frame of the current label view
        self.registrationView.activeFieldFrame = textField.superview?.frame
        return true
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let textfield = textField as? AppTextfield else { return true }
        
        // Check if the field is filled or if there is a forbidden character .
        return textfield.checkInputPermission(string)
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let textfield = textField as? AppTextfield else { return }

        // Check if the field is filled with the minimum number of characters
        textfield.checkMinCharAnimation()
        registrationView.checkFilledFieldsAnimation()
    }
}

// MARK: - UITextViewDelegate

extension SignUpViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        // Save the frame of the current label view
        self.registrationView.activeFieldFrame = textView.superview?.frame
        return true
    }

    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        // Checking if the field is full
        guard let textView = textView as? AppTextView else { return true }
        return textView.checkInputPermission(text)
    }

    func textViewDidChange(_ textView: UITextView) {
        guard let textview = textView as? AppTextView else { return }

        // Disable/Enable placeholder
        textview.checkFieldIsForPlaceholder()
        // Check if the field is filled with the minimum number of characters
        textview.checkMinCharAnimation()
        registrationView.checkFilledFieldsAnimation()
    }
}
