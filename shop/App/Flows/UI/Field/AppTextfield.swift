//
//  AppTextfield.swift
//  shop
//
//  Created by Ke4a on 29.10.2022.
//

import UIKit

extension AppTextfield {
    /// Settings right view.
    enum RightView {
        /// Adds a show password button to the right margin of the view.
        case secure
        /// Adds a check mark to the right edge of the view. If the field is filled.
        case checkMark
        /// Doesn't add anything.
        case none
    }
}

/// Application-style text field with fullness animation and show password button.
class AppTextfield: UITextField {
    // MARK: - Visual Components

    /// Checkbox image for filled field.
    private lazy var checkImageView: UIImageView = {
        let image = UIImage(named: AppDataScreen.image.checkMark)
        let view = UIImageView(image: image)
        return view
    }()

    /// Button secure to show password.
    private lazy var secureButton = UIButton(type: .custom)

    // MARK: - Public Properties

    /// Is the field filled to the minimum number char.
    var isFill: Bool {
        guard let text = self.text else { return false }
        return text.count >= minChar
    }

    // MARK: - Private Properties

    /// What will be displayed in the right view.
    private var mode: RightView
    /// Color incomplete field
    private var incompleteColor: UIColor
    /// Color complete field
    private var completeColor: UIColor
    /// Minimum number of characters for a field.
    private var minChar: Int
    /// Minimum number of characters for a field.
    private var maxChar: Int

    // MARK: - Initialization

    /// Application textfield with animation of filled fields and password display.
    ///
    /// - Parameters:
    ///   - placeholder: Text placholder.
    ///   - incompleteColor: Color for for not filled field.
    ///   - completeColor: Color for for  filled field.
    ///   - minChar: The number at which the field is considered not  filled. (default value 3)
    ///   - maxChar: The number at which the field is considered filled. (default value 0 - no limit)
    ///   - mode: What will be displayed in the right view of the textfield. (default value none)
    init(_ placeholder: String,
         incompleteColor: UIColor,
         completeColor: UIColor,
         minChar: Int = 3,
         maxChar: Int = 0,
         mode: RightView = .none) {

        self.incompleteColor = incompleteColor
        self.completeColor = completeColor
        self.minChar = minChar
        self.maxChar = maxChar
        self.mode = mode
        super.init(frame: .zero)
        self.placeholder = placeholder
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setting UI Methods

    /// Settings for the visual part.
    private func setupUI() {
        setPadding(left: 8, right: 8)
        backgroundColor = AppStyles.color.background
        layer.borderWidth = AppStyles.layer.borderWidth.incomplete
        layer.cornerRadius = AppStyles.layer.cornerRadius
        layer.borderColor = incompleteColor.cgColor
        textColor = incompleteColor
        autocapitalizationType = .none

        switch mode {
        case .secure:
            addSecureButton()
        case .checkMark:
            addCheckImage()
        case .none:
            break
        }

        setUITests()
    }

    /// Adds a show password button to the right view.
    private func addSecureButton() {
        isSecureTextEntry = true

        secureButton.setImage(UIImage(named: AppDataScreen.image.eyeOpen), for: .normal)
        secureButton.setImage(UIImage(named: AppDataScreen.image.eyeClose), for: .selected)
        // right padding button
        secureButton.imageEdgeInsets = UIEdgeInsets(top: 0,
                                                    left: -(AppStyles.size.padding * 2),
                                                    bottom: 0,
                                                    right: 0)
        secureButton.tintColor = incompleteColor

        rightView = secureButton
        rightViewMode = .always

        secureButton.addTarget(self, action: #selector(actionSecureButton), for: .touchUpInside)
    }

    /// Adds a check mark for full field to right view.
    private func addCheckImage() {
        checkImageView.tintColor = .clear
        checkImageView.contentMode = .center
        // right padding for check mark
        let view = UIView(frame: .init(x: 0, y: 0,
                                       width: checkImageView.frame.width + AppStyles.size.padding,
                                       height: checkImageView.frame.height))
        view.addSubview(checkImageView)

        rightView = view
        rightViewMode = .always
    }

    // MARK: - Public Methods

    /// Checks the minimum number of characters and starts the animation if the field is full.
    func checkMinCharAnimation() {
        guard let count = text?.count else { return }

        // An additional color check to ensure that old values are not overwritten with the same ones.
        if count >= minChar && textColor == incompleteColor {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut) {
                    switch self.mode {
                    case .checkMark:
                        self.checkImageView.tintColor = self.completeColor
                    default:
                        break
                    }

                    self.textColor = self.completeColor
                    self.layer.borderColor = self.completeColor.cgColor
                    self.layer.borderWidth = AppStyles.layer.borderWidth.complete
                }
            }
            // An additional color check to ensure that old values are not overwritten with the same ones.
        } else if count < minChar && textColor == completeColor {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut) {
                    switch self.mode {
                    case .checkMark:
                        self.checkImageView.tintColor = .clear
                    default:
                        break
                    }

                    self.textColor = self.incompleteColor
                    self.layer.borderColor = self.incompleteColor.cgColor
                    self.layer.borderWidth = AppStyles.layer.borderWidth.incomplete
                }
            }
        }
    }

    /// Checks the maximum number of characters and unallowed characters,.
    ///  In case of prohibition it starts the animation.
    /// - Parameter character: Сharacter to check.
    /// - Returns: Is input allowed.
    func checkInputPermission(_ character: String) -> Bool {
        // Checking if a character is a backspace
        if let char = character.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }

        guard let count = text?.count else { return true }

        // If max char is zero, then there is no limit.
        // Check for a forbidden character or field overflow.
        if (count + character.count > maxChar && maxChar != 0) || checkWrongCharacter(character: character) {
            errorAnimation()
            return false
        }

        return true
    }

    // MARK: - Private Methods

    /// Checking if a character is prohibited.
    /// - Parameter character: Сharacter to check.
    /// - Returns: Whether the symbol is prohibited.
    private func checkWrongCharacter(character: String) -> Bool {
        guard let textContentType = textContentType else { return false }

        switch textContentType {
        case .creditCardNumber:
            return !character.isNumbers
        case .familyName:
            return !character.isLetters
        default:
            return false
        }
    }

    /// Field error shake animation.
    private func errorAnimation() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.03
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x, y: center.y - 2))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x, y: center.y + 2))
        layer.add(animation, forKey: "position")
    }

    /// Set identifier for components.
    private func setUITests() {
        self.accessibilityIdentifier = "appTextfield"
        secureButton.accessibilityIdentifier = "secureButton"
        checkImageView.accessibilityIdentifier = "checkMark"
    }

    // MARK: - Actions

    ///  Button action show password.
    @objc private func actionSecureButton() {
        isSecureTextEntry.toggle()
        secureButton.isSelected.toggle()

        if secureButton.isSelected {
            secureButton.tintColor = completeColor
        } else {
            secureButton.tintColor = incompleteColor
        }
    }
}
