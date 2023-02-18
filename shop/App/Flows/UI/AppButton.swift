//
//  AppButton.swift
//  shop
//
//  Created by Ke4a on 29.10.2022.
//

import UIKit

/// Application-style button with animation click and load indicator.
class AppButton: UIButton {
    // MARK: - Private Properties

    /// Text title.
    private var text: String?

    // MARK: - Visual Components

    /// Load indicator.
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = AppStyles.color.background
        return activityIndicator
    }()

    // MARK: - Initialization

    /// Application button with animation click and load indicator.
    /// - Parameters:
    ///   - tittle: Text button.
    ///   - activityIndicator: Loading animation.
    init(tittle: String, activityIndicator: Bool) {
        super.init(frame: .zero)
        setTitle(tittle, for: .normal)
        setupUI()

        if activityIndicator {
            self.text = tittle
            addAcivityIndiactor()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setting UI Methods
    /// Application-style label view contains inside filed.
    /// Settings for the visual part.
    private func setupUI() {
        setTitleColor(.lightGray, for: .disabled)
        setTitleColor(.white, for: .normal)

        layer.borderWidth = AppStyles.layer.borderWidth.incomplete
        layer.borderColor = AppStyles.color.incomplete.cgColor
        layer.cornerRadius = AppStyles.layer.cornerRadius
    }

    /// Adds loading indicator.
    private func addAcivityIndiactor() {
        addSubview(self.activityIndicator)
        NSLayoutConstraint.activate([
            self.activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - Public Methods

    /// Click animation.
    func clickAnimation() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.20, delay: 0, options: [.autoreverse, .curveEaseInOut]) {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            } completion: { _ in
                self.transform = CGAffineTransform.identity
            }
        }
    }

    /// Button access.
    /// - Parameter enable: Enable button.
    func setIsEnable(enable: Bool) {
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

    /// Shows loading animation.
    /// - Parameter isLoading: Enable loading animation.
    func showLoadingIndicator(_ isLoading: Bool) {
        // Checks that there is no unnecessary overwriting of data
        if isLoading && text != nil {
            setTitle("", for: .normal)
            activityIndicator.isHidden = !isLoading
            activityIndicator.startAnimating()
        } else if text != nil {
            setTitle(text, for: .normal)
            activityIndicator.isHidden = !isLoading
            activityIndicator.stopAnimating()
        }
    }
}
