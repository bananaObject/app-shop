//
//  QtView.swift
//  shop
//
//  Created by Ke4a on 22.11.2022.
//

import UIKit

/// Item counter with buttons. With the ability to fill buttons.
class QtView: UIStackView {
    // MARK: - Visual Components

    private lazy var removeItemButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: AppDataScreen.image.minus)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        button.layer.cornerRadius = AppStyles.layer.cornerRadius
        return button
    }()

    private lazy var qtLabel: UILabel = {
        let label = UILabel()
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = AppStyles.color.complete
        return label
    }()

    private lazy var addItemButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: AppDataScreen.image.plus)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = AppStyles.layer.cornerRadius
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        return button
    }()

    // MARK: - Public Properties

    /// Button background fill,
    var isFillButton: Bool = false {
        didSet {
            checkFillButton()
        }
    }

    // MARK: - Private Properties

    /// Maximum amount.
    private var limitMax: Int = 99
    /// Minimal amount.
    private var limitMin: Int = 0

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        setQt(0)
        checkFillButton()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var backgroundColor: UIColor? {
        willSet {
            qtLabel.backgroundColor = newValue
        }
    }

    // MARK: - Setting UI Methods

    /// Settings visual components.
    private func setupUI() {
        spacing = 8
        translatesAutoresizingMaskIntoConstraints = false
        distribution = .fillEqually
        addArrangedSubview(removeItemButton)
        addArrangedSubview(qtLabel)
        addArrangedSubview(addItemButton)
    }

    // MARK: - Public Methods

    /// Changes the  of units with a check for disabling buttons if beyond the limits.
    /// - Parameter qt: Product quantity.
    func setQt(_ qt: Int) {
        qtLabel.text = "x\(qt)"
        limitCheckQt(qt)
    }

    /// Set product quantity limits. The default is 0-99.
    /// - Parameters:
    ///   - min:Max quantity.
    ///   - max: Min quantity.
    func setLimits(_ min: Int, _ max: Int) {
        limitMax = max
        limitMin = min
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

    /// Checking whether to fill the buttons.
    private func checkFillButton() {
        removeItemButton.backgroundColor = isFillButton ?
        AppStyles.color.complete : AppStyles.color.background
        removeItemButton.tintColor = isFillButton ?
        AppStyles.color.background : AppStyles.color.complete

        addItemButton.backgroundColor = isFillButton ?
        AppStyles.color.complete : AppStyles.color.background
        addItemButton.tintColor = isFillButton ?
        AppStyles.color.background : AppStyles.color.complete
    }

    /// Checking the limit of items, to disable buttons.
    /// - Parameter qt: Product qt.
    private func limitCheckQt(_ qt: Int) {
        if qt > limitMin && !removeItemButton.isEnabled {
            removeItemButton.isEnabled = true

            if isFillButton {
                removeItemButton.backgroundColor = AppStyles.color.complete
            } else {
                removeItemButton.tintColor = AppStyles.color.complete
            }
        } else if qt <= limitMin && removeItemButton.isEnabled {
            removeItemButton.isEnabled = false

            if isFillButton {
                removeItemButton.backgroundColor = AppStyles.color.incomplete
            } else {
                removeItemButton.tintColor = AppStyles.color.incomplete
            }
        }

        if qt < limitMax && !addItemButton.isEnabled {
            addItemButton.isEnabled = true

            if isFillButton {
                addItemButton.backgroundColor = AppStyles.color.complete
            } else {
                addItemButton.tintColor = AppStyles.color.complete
            }
        } else if qt >= limitMax && addItemButton.isEnabled {
            addItemButton.isEnabled = false
            
            if isFillButton {
                addItemButton.backgroundColor = AppStyles.color.incomplete
            } else {
                addItemButton.tintColor = AppStyles.color.incomplete
            }
        }
    }
}
