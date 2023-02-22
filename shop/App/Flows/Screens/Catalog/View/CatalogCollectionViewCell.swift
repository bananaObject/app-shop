//
//  CatalogCollectionViewCell.swift
//  shop
//
//  Created by Ke4a on 11.11.2022.
//

import UIKit

/// Cell  ouput.
protocol CatalogCellOutput {
    /// Adds  product to basket  by index.
    /// - Parameter index: Index product in collection.
    /// - Parameter qt: Product quantity added to cart.
    func addProductToCart(index: Int, qt: Int)
}

/// Cell of catalog collection view .
class CatalogCollectionViewCell: UICollectionViewCell {
    // MARK: - Visual Components

    /// Product image.
    private lazy var productImage: UIImageView = {
        let image = UIImage()
        let view = UIImageView()
        view.image = image
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        return view
    }()

    /// Product name label.
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = AppStyles.color.main
        return label
    }()

    /// Product price label.
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = AppStyles.color.main
        label.textAlignment = .right
        return label
    }()

    /// Add button.
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = AppStyles.color.main
        button.setTitleColor(AppStyles.color.main, for: .normal)
        button.setTitleColor(AppStyles.color.background, for: .selected)
        button.setTitle("Add", for: .normal)
        return button
    }()

    // MARK: - Static Properties

    /// Сell identifier.
    static var identifier = "CatalogCollectionViewCell"

    // MARK: - Public Properties

    /// The  delegate view.
    weak var delegate: (AnyObject & CatalogCellOutput)?

    // MARK: - Private Properties

    /// Quantity of goods in the basket
    private var quantity = 0

    /// The old value of the quantity of goods in the cart
    private var oldQuantity = 0

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Prepare For Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        priceLabel.text = nil
        productImage.image = nil
    }

    // MARK: - Setting UI Methods

    /// Settings for the visual part.
    private func setupUI() {
        layer.borderWidth = AppStyles.layer.borderWidth.complete
        layer.borderColor = AppStyles.color.incomplete.cgColor
        layer.cornerRadius = AppStyles.layer.cornerRadius
        
        addButton.layer.borderWidth = layer.borderWidth
        addButton.layer.borderColor = layer.borderColor
        addButton.layer.cornerRadius = layer.cornerRadius
        addButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        addButton.addTarget(self, action: #selector(actionAddButton), for: .touchUpInside)

        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                           constant: AppStyles.size.padding),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            
        ])

        contentView.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            addButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            addButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.16)
        ])

        contentView.addSubview(productImage)
        NSLayoutConstraint.activate([
            productImage.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,
                                              constant: AppStyles.size.padding),
            productImage.bottomAnchor.constraint(equalTo: addButton.topAnchor,
                                                 constant: -AppStyles.size.padding / 2),
            productImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                  constant: AppStyles.size.padding),
            productImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                   constant: -AppStyles.size.padding)
        ])

        contentView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: addButton.topAnchor),
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor,
                                                 constant: -AppStyles.size.padding)
        ])
    }

    // MARK: - Private Methods

    /// Settings button add to cart.
    /// - Parameter quantity: The number of items added to the cart.
    private func setupButton(quantity: Int) {
        if quantity > 0 {
            addButton.isSelected = true
            addButton.setTitle("x \(quantity)", for: .selected)
            addButton.backgroundColor = AppStyles.color.main
        } else {
            addButton.isSelected = false
            addButton.backgroundColor = AppStyles.color.background
        }
    }

    private func buttonClickAnimation() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut]) {
            self.addButton.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)

            if !self.addButton.isSelected {
                self.addButton.isSelected = true
                self.addButton.backgroundColor = AppStyles.color.main
            }
        } completion: { _ in
            self.addButton.transform = CGAffineTransform.identity
        }
    }

    // MARK: - Public Methods

    /// Cell configuration.
    /// - Parameters:
    ///   - name: Product name.
    ///   - price: Product price.
    ///   - index: Item index.
    ///   - quantity: Number of items in the cart.
    ///   - data: Image data.
    func configure(name: String, price: Int, index: Int, quantity: Int?, image data: Data?) {
        nameLabel.text = name
        if let formatString = price.formatThousandSeparator() {
            priceLabel.text = "\(formatString) ₽"
        } else {
            priceLabel.text = "\(price) ₽"
        }
        // Add index product to tag
        tag = index
        
        let qt = quantity ?? 0
        self.quantity = qt
        oldQuantity = qt
        setupButton(quantity: qt)
        
        guard let data = data else { return }
        productImage.image = UIImage(data: data)
    }

    // MARK: - Actions

    /// Button action.
    @objc func actionAddButton() {
        quantity += 1
        addButton.setTitle("x \(quantity)", for: .selected)

        buttonClickAnimation()
        // Will call the request function only once when all the clicks have accumulated
        NSObject.cancelPreviousPerformRequests(
            withTarget: self as Any,
            selector: #selector(actionDebounce),
            object: nil)
        perform(#selector(actionDebounce), with: nil, afterDelay: 1)

    }

    /// Adding a new quantity of goods to the cart
    @objc private  func actionDebounce() {
        let qtDifference = quantity - oldQuantity
        oldQuantity = quantity
        delegate?.addProductToCart(index: tag, qt: qtDifference)
    }
}
