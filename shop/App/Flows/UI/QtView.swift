//
//  QtView.swift
//  shop
//
//  Created by Ke4a on 22.11.2022.
//

import UIKit

/// Item counter with buttons.
class QtView: UIStackView {
    // MARK: - Visual Components

    private lazy var removeItemButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: AppDataScreen.image.minus)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = AppStyles.layer.cornerRadius
        button.backgroundColor = AppStyles.color.complete
        button.tintColor = AppStyles.color.background
        return button
    }()

    private lazy var qtLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = AppStyles.color.complete
        label.backgroundColor = AppStyles.color.background
        return label
    }()

    private lazy var addItemButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: AppDataScreen.image.plus)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = AppStyles.layer.cornerRadius
        button.backgroundColor = AppStyles.color.complete
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        button.tintColor = AppStyles.color.background
        return button
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setting UI Methods

    /// Settings visual components.
    private func setupUI() {
        spacing = 8
        translatesAutoresizingMaskIntoConstraints = false
        distribution = .fillEqually
        backgroundColor = AppStyles.color.background
        addArrangedSubview(removeItemButton)
        addArrangedSubview(qtLabel)
        addArrangedSubview(addItemButton)
    }
    // MARK: - Public Methods

    /// Changes the  of units with a check for disabling buttons if beyond the limits.
    /// - Parameter qt: Product quantity.
    func setQt(_ qt: Int) {
        qtLabel.text = "x \(qt)"
        limitCheckQt(qt)
    }

    /// Adding an action to the add/remove product buttons
    /// - Parameters:
    ///   - delegate: The class in which the action is located.
    ///   - actionAdd: Action add item.
    ///   - actionRemove: Action remove item.
    func addTarget(_ delegate: AnyObject, actionAdd: Selector, actionRemove: Selector) {
        addItemButton.addTarget(delegate, action: actionAdd, for: .touchUpInside)
        removeItemButton.addTarget(delegate, action: actionRemove, for: .touchUpInside)
    }

    // MARK: - Private Methods

    /// Checking the limit of items, to disable buttons.
    /// - Parameter qt: Product qt.
    private func limitCheckQt(_ qt: Int) {
        if qt > 0 && !removeItemButton.isEnabled {
            removeItemButton.isEnabled = true
            removeItemButton.backgroundColor = AppStyles.color.complete
        } else if qt <= 0 && removeItemButton.isEnabled {
            removeItemButton.isEnabled = false
            removeItemButton.backgroundColor = AppStyles.color.incomplete
        }
    }
}
