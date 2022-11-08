//
//  SignUpView.swift
//  shop
//
//  Created by Ke4a on 08.11.2022.
//

import UIKit

/// View "sign up" screen.
class SignUpView: UIView {
    // MARK: - Visual Components

    /// Vertical scrollView.
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        let insets = UIEdgeInsets.zero
        scroll.contentInset = insets
        scroll.scrollIndicatorInsets = insets
        scroll.delaysContentTouches = false
        return scroll
    }()

    /// Box view components .
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.spacing = AppStyles.size.padding
        stack.axis = .vertical
        stack.backgroundColor = AppStyles.color.background
        return stack
    }()

    // MARK: - Public Properties

    /// Array of texts of the screen fields.
    var fieldsText: [String?] {
        stackView.arrangedSubviews.map { view in
            guard let label = view as? AppLabelView else {
                return nil
            }

            let text: String

            if let textfield = label.field as? UITextField {
                text = textfield.text ?? "Error"
            } else if let textview = label.field as? UITextView {
                text = textview.text ?? "Error"
            } else {
                return nil
            }

            return text
        }
    }
    
    /// Frame field is currently in use. For scroll.
    var activeFieldFrame: CGRect?

    /// Screen component data.
    var components: [AppDataScreen.signUp.Component]?

    /// The  delegate controller.
    weak var delegate: UIViewController?

    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setting UI Methods

    /// Settings for the visual part.
    func setupUI() {
        
        backgroundColor = AppStyles.color.background

        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                            constant: AppStyles.size.padding),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                               constant: -AppStyles.size.padding),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                constant: AppStyles.size.padding),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                 constant: -AppStyles.size.padding)
        ])

        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        scrollView.contentSize = stackView.frame.size
        scrollView.gestureRecognizers?.forEach {
            $0.delaysTouchesBegan = true
            $0.cancelsTouchesInView = false
        }
    }

    /// Adds component to stackview.
    func addComponentsStackview(components: [AppDataScreen.signUp.Component]?) {
        guard let components = components else { return }
        self.components = components

        components.forEach { item in
            switch item {
            case .bio:
                let field = AppTextView(item.placeholder,
                                        incompleteColor: AppStyles.color.incomplete,
                                        completeColor: AppStyles.color.complete,
                                        minChar: item.minChar,
                                        maxChar: item.maxChar,
                                        checkMark: true)

                // Make the textview the same font as all fields
                if let labelView = stackView.arrangedSubviews.last as? AppLabelView,
                   let textfield = labelView.field as? UITextField {
                    field.font = textfield.font
                }

                if let delegate = delegate as? UITextViewDelegate {
                    field.delegate = delegate
                }

                NSLayoutConstraint.activate([
                    field.heightAnchor.constraint(equalToConstant: AppStyles.size.height.textfield * 3)
                ])

                // Add label for field
                let view = AppLabelView(text: item.rawValue, field: field)

                stackView.addArrangedSubview(view)
            case .submitButton:
                let button = AppButton(tittle: item.rawValue, activityIndicator: true)
                // The button is not available because initially the fields are not filled
                button.setIsEnable(enable: false)

                NSLayoutConstraint.activate([
                    button.heightAnchor.constraint(equalToConstant: AppStyles.size.height.button)
                ])

                stackView.addArrangedSubview(button)
            default:
                let field = AppTextfield(item.placeholder,
                                         incompleteColor: AppStyles.color.incomplete,
                                         completeColor: AppStyles.color.complete,
                                         minChar: item.minChar,
                                         maxChar: item.maxChar,
                                         mode: .checkMark)

                if let delegate = delegate as? UITextFieldDelegate {
                    field.delegate = delegate
                }

                // Settings field
                switch item {
                case .firstName, .lastname, .gender:
                    field.textContentType = .familyName
                case .email:
                    field.textContentType = .emailAddress
                    field.keyboardType = .emailAddress
                case .creditCard:
                    field.textContentType = .creditCardNumber
                default:
                    break
                }

                NSLayoutConstraint.activate([
                    field.heightAnchor.constraint(equalToConstant: AppStyles.size.height.textfield)
                ])

                let view = AppLabelView(text: item.rawValue, field: field)
                stackView.addArrangedSubview(view)
            }
        }
    }

    // MARK: - Public Methods

    /// Adding an Action to a Button
    /// - Parameter action: Button action.
    func addTargetSubmitButton(_ action: Selector) {
        guard let index = components?.firstIndex(where: { $0 == .submitButton }),
              let button = stackView.arrangedSubviews[index] as? UIButton else { return }

        button.addTarget(delegate, action: action, for: .touchUpInside)
    }

    /// Resizing the view.
    /// - Parameter contentInsets: The inset distances for views.
    func setSize(contentInsets: UIEdgeInsets) {
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets

        if contentInsets == .zero {
            return
        }
        
        if let viewFrame = activeFieldFrame {
            scrollView.scrollRectToVisible(viewFrame, animated: true)
        } else {
            // If for some reason the required frame is missing, it will scroll to the very bottom
            let viewFrame = stackView.arrangedSubviews.last?.frame ?? .zero
            scrollView.scrollRectToVisible(viewFrame, animated: true)
        }
    }

    /// Animation  button if the fields are filled or unfilled.
    func checkFilledFieldsAnimation() {
        // I check the array for first false so as not to go through the entire array
        let incompleteFields = self.stackView.arrangedSubviews.contains(where: { view in
            guard let view = view as? AppLabelView else { return false }

            if let field = view.field as? AppTextView {
                return !field.isFill
            } else if let field = view.field as? AppTextfield {
                return !field.isFill
            } else {
                return false
            }
        })

        guard let button = stackView.arrangedSubviews.first(where: { $0 is AppButton }) as? AppButton else { return }

        button.setIsEnable(enable: !incompleteFields)
    }

    /// Shows loading indicator in button  view controller.
    /// - Parameter isLoading: Enable/disable loading indicator.
    func showLoadingButton(_ isLoading: Bool) {
        guard let index = components?.firstIndex(of: .submitButton),
              let button = stackView.arrangedSubviews[index] as? AppButton else { return }
        button.showLoadingIndicator(isLoading)
    }
}