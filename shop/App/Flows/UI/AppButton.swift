//
//  AppButton.swift
//  shop
//
//  Created by Ke4a on 29.10.2022.
//

import UIKit

class AppButton: UIButton {
    // MARK: - Initialization

    init(text: String) {
        super.init(frame: .zero)
        setTitle(text, for: .normal)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setting UI Methods

    private func setupUI() {
        setTitleColor(.lightGray, for: .disabled)
        setTitleColor(.white, for: .normal)

        layer.borderWidth = 0.7
        layer.borderColor = AppStyles.color.incomplete.cgColor
        layer.cornerRadius = 10
    }
    
    // MARK: - Public Methods

    func clickAnimation() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.20, delay: 0, options: [.autoreverse, .curveEaseInOut]) {
                self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            } completion: { _ in
                self.transform = CGAffineTransform.identity
            }
        }
    }

    func buttonIsEnable(enable: Bool) {
        isEnabled = enable

        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut) {
                if enable {
                    self.backgroundColor = AppStyles.color.complete
                } else {
                    self.backgroundColor = AppStyles.color.background
                }
            }
        }
    }
}
