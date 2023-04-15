//
//  AppLabelView.swift
//  shop
//
//  Created by Ke4a on 04.11.2022.
//

import UIKit

/// Application-style label view contains inside filed.
class AppLabelView: UIView {
    // MARK: - Visual Components

    /// Label field.
    private var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppStyles.color.main
        return label
    }()

    /// Field.
    private(set) var field: UIView

    // MARK: - Initialization

    /// Application label with a field inside. Provides public access to the field.
    /// - Parameters:
    ///   - text: Label text.
    ///   - field: Field inside the label.
    init(text: String, field: UIView ) {
        self.field = field
        self.label.text = text
        super.init(frame: .zero)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setting UI Methods

    /// Settings for the visual part.
    private func setupUI() {
        let padding = AppStyles.size.padding
        
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding)
        ])

        field.translatesAutoresizingMaskIntoConstraints = false

        addSubview(field)
        NSLayoutConstraint.activate([
            field.topAnchor.constraint(equalTo: label.bottomAnchor, constant: padding),
            field.leadingAnchor.constraint(equalTo: leadingAnchor),
            field.trailingAnchor.constraint(equalTo: trailingAnchor),
            field.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Public Methods

    override var isFirstResponder: Bool {
        field.isFirstResponder
    }

    override func resignFirstResponder() -> Bool {
        field.resignFirstResponder()
    }

    override func becomeFirstResponder() -> Bool {
        field.becomeFirstResponder()
    }

    override var canResignFirstResponder: Bool {
        field.canResignFirstResponder
    }

    override var canBecomeFirstResponder: Bool {
        field.canBecomeFirstResponder
    }
}
