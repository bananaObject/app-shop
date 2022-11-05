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
        case secure
        case checkMark
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
    private var mode: RightView = .none

    /// Color incomplete field
    private var incompleteColor: UIColor = .clear
    /// Color complete field
    private var completeColor: UIColor = .clear

    /// Minimum number of characters for a field.
    private var minChar: Int = 1

    /// Minimum number of characters for a field.
    private var maxChar: Int = 0

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
         mode: RightView = .none
    ) {
        super.init(frame: .zero)
        
        self.placeholder = placeholder
        self.incompleteColor = incompleteColor
        self.completeColor = completeColor
        self.minChar = minChar
        self.maxChar = maxChar
        self.mode = mode

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
        layer.borderWidth = 0.7
        layer.cornerRadius = 10
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
    func checkMinCharAnimation() -> Bool {
        guard let count = text?.count else { return true }

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
                    self.layer.borderWidth = 1
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
                    self.layer.borderWidth = 0.7
                }
            }
        }

        return count >= minChar
    }

    /// Checks the maximum number of characters and starts the animation if the field is overflowing.
    /// - Returns: The field is overflowing.
    func checkMaxCharAnimation() -> Bool {
        guard let count = text?.count else { return true }

        // If max char is zero, then there is no limit.
        if count >= maxChar && maxChar != 0 {
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.03
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x, y: center.y - 2))
            animation.toValue = NSValue(cgPoint: CGPoint(x: center.x, y: center.y + 2))
            layer.add(animation, forKey: "position")
            return false
        }

        return true
    }
    
    // MARK: - Actions

    ///  Button action show passwor
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
