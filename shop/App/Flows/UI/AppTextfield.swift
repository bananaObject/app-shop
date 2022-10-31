//
//  AppTextfield.swift
//  shop
//
//  Created by Ke4a on 29.10.2022.
//

import UIKit

class AppTextfield: UITextField {
    // MARK: - Visual Components

    private var rightButton = UIButton(type: .custom)

    // MARK: - Private Properties

    private var defaultColor: UIColor = .clear
    private var completeColor: UIColor = .clear

    // MARK: - Initialization

    init(_ placeholder: String,
         secureEnable: Bool = false,
         defaultColor: UIColor,
         completeColor: UIColor
    ) {
        super.init(frame: .zero)
        
        self.placeholder = placeholder
        self.defaultColor = defaultColor
        self.completeColor = completeColor

        setupUI()

        if secureEnable {
            isSecureTextEntry = secureEnable
            addSecureButton()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setting UI Methods

    private func setupUI() {
        backgroundColor = AppStyles.color.background
        setPadding(left: 8, right: 8)
        layer.borderWidth = 0.7
        layer.cornerRadius = 10
        layer.borderColor = defaultColor.cgColor
        textColor = defaultColor
        autocapitalizationType = .none
    }

    // MARK: - Private Methods
    
    private func addSecureButton() {
        rightButton.setImage(UIImage(named: AppStyles.image.eyeOpen), for: .normal)
        rightButton.setImage(UIImage(named: AppStyles.image.eyeClose), for: .selected)
        rightButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        rightButton.tintColor = defaultColor
        rightView = rightButton
        rightViewMode = .always

        rightButton.addTarget(self, action: #selector(actionSecureButton), for: .touchUpInside)
    }

    // MARK: - Public Methods

    /// Animation for the filled field.
    /// - Parameter complete: Is the field filled.
    func animationComplete(_ complete: Bool) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut) {
                if complete {
                    self.textColor = self.completeColor
                    self.layer.borderColor = self.completeColor.cgColor
                    self.layer.borderWidth = 1
                } else {
                    self.textColor = self.defaultColor
                    self.layer.borderColor = self.defaultColor.cgColor
                    self.layer.borderWidth = 0.7
                }
            }
        }
    }

    // MARK: - Actions

    @objc private func actionSecureButton(_ sender: Any) {
        isSecureTextEntry.toggle()
        rightButton.isSelected.toggle()

        if rightButton.isSelected {
            rightButton.tintColor = completeColor
        } else {
            rightButton.tintColor = defaultColor
        }
    }
}
