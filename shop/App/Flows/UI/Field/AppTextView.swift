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

    private var checkMarkIsEnable: Bool = false

    /// Color incomplete field
    private var incompleteColor: UIColor = .clear
    /// Color complete field
    private var completeColor: UIColor = .clear

    /// Minimum number of characters for a field.
    private var minChar: Int = 1

    /// Minimum number of characters for a field.
    private var maxChar: Int = 0

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
        super.init(frame: .zero, textContainer: .none)

        self.incompleteColor = incompleteColor
        self.completeColor = completeColor
        self.minChar = minChar
        self.maxChar = maxChar
        self.checkMarkIsEnable = checkMark

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
        layer.borderWidth = 0.7
        layer.cornerRadius = 10
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
    func checkMinCharAnimation() -> Bool {
        guard let count = text?.count else { return true }

        // An additional color check to ensure that old values are not overwritten with the same ones.
        if count >= minChar && textColor == incompleteColor {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut) {
                    self.checkImageView.tintColor = self.completeColor
                    self.textColor = self.completeColor
                    self.layer.borderColor = self.completeColor.cgColor
                    self.layer.borderWidth = 1
                }
            }
            // An additional color check to ensure that old values are not overwritten with the same ones.
        } else if count < minChar && textColor == completeColor {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut) {
                    self.checkImageView.tintColor = .clear
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
        }

        return count >= maxChar
    }
}
