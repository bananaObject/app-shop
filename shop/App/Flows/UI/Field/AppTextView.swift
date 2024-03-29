//
//  AppTextView.swift
//  shop
//
//  Created by Ke4a on 01.11.2022.
//

import UIKit

/// Application-style text view with fullness animation.
class AppTextView: UITextView {
    // MARK: - Visual Components

    /// Checkbox image for filled field.
    private lazy var checkImageView: UIImageView = {
        let image = UIImage(named: AppDataScreen.image.checkMark)
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// Placeholder field.
    private lazy var placeholder: UILabel = {
        let label = UILabel()
        label.textColor = incompleteColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0.7
        return label
    }()

    // MARK: - Public Properties

    /// Is the field filled to the minimum number char.
    var isFill: Bool {
        return text.count >= minChar
    }

    // MARK: - Private Properties

    private var checkMarkIsEnable: Bool
    /// Color incomplete field
    private var incompleteColor: UIColor
    /// Color complete field
    private var completeColor: UIColor
    /// Minimum number of characters for a field.
    private var minChar: Int
    /// Minimum number of characters for a field.
    private var maxChar: Int

    // MARK: - Initialization

    /// Application view text with animation of filled fields.
    ///
    /// - Parameters:
    ///   - placeholder: Text placholder.
    ///   - incompleteColor: Color for for not filled field.
    ///   - completeColor: Color for for  filled field.
    ///   - minChar: The number at which the field is considered not filled. (default value 3)
    ///   - maxChar: The number at which the field is considered filled. (default value 0 - no limit)
    ///   - checkMark: What will be displayed in the right view of the textview. (default value false)
    init(_ placeholder: String,
         incompleteColor: UIColor,
         completeColor: UIColor,
         minChar: Int = 3,
         maxChar: Int = 0,
         checkMark: Bool = false
    ) {
        self.incompleteColor = incompleteColor
        self.completeColor = completeColor
        self.minChar = minChar
        self.maxChar = maxChar
        self.checkMarkIsEnable = checkMark
        super.init(frame: .zero, textContainer: .none)
        self.placeholder.text = placeholder
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setting UI Methods

    /// Settings for the visual part.
    private func setupUI() {
        textColor = incompleteColor

        backgroundColor = AppStyles.color.background
        layer.borderWidth = AppStyles.layer.borderWidth.incomplete
        layer.cornerRadius = AppStyles.layer.cornerRadius
        layer.borderColor = incompleteColor.cgColor
        autocapitalizationType = .none

        addSubview(placeholder)
        NSLayoutConstraint.activate([
            placeholder.topAnchor.constraint(equalTo: topAnchor),
            placeholder.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                 constant: AppStyles.size.padding),
            placeholder.heightAnchor.constraint(equalToConstant: AppStyles.size.height.textfield)
        ])

        if checkMarkIsEnable {
            addCheckImage()
        }
    }

    /// Adds a check mark for full field.
    private func addCheckImage() {
        checkImageView.tintColor = .clear

        addSubview(checkImageView)
        NSLayoutConstraint.activate([
            checkImageView.topAnchor.constraint(equalTo: topAnchor, constant: AppStyles.size.padding),
            checkImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                     constant: -AppStyles.size.padding),
            checkImageView.heightAnchor.constraint(equalToConstant: AppStyles.size.height.textfield * 0.5),
            checkImageView.widthAnchor.constraint(equalTo: checkImageView.heightAnchor)
        ])

    }

    // MARK: - Public Methods

    /// Checks if there is text in the field, if there is, it hide the placeholder.
    func checkFieldIsForPlaceholder () {
        if text.isEmpty && placeholder.isHidden == true {
            placeholder.isHidden = false
        } else if placeholder.isHidden == false {
            placeholder.isHidden = true
        }
    }

    /// Check animation for the filled field.
    func checkMinCharAnimation() {
        guard let count = text?.count else { return }

        // An additional color check to ensure that old values are not overwritten with the same ones.
        if count >= minChar && textColor == incompleteColor {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut) {
                    self.checkImageView.tintColor = self.completeColor
                    self.textColor = self.completeColor
                    self.layer.borderColor = self.completeColor.cgColor
                    self.layer.borderWidth = AppStyles.layer.borderWidth.complete
                }
            }
            // An additional color check to ensure that old values are not overwritten with the same ones.
        } else if count < minChar && textColor == completeColor {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut) {
                    self.checkImageView.tintColor = .clear
                    self.textColor = self.incompleteColor
                    self.layer.borderColor = self.incompleteColor.cgColor
                    self.layer.borderWidth = AppStyles.layer.borderWidth.incomplete
                }
            }
        }
    }

    /// Checks the maximum number of characters.
    ///  In case of prohibition it starts the animation.
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
        if count + character.count > maxChar && maxChar != 0 {
            errorAnimation()
            return false
        }

        return true
    }

    // MARK: - Private Methods

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
}
