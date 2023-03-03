//
//  OtherProductView.swift
//  shop
//
//  Created by Ke4a on 19.11.2022.
//

import UIKit

/// Delegate view.
protocol OtherProductViewDelegate: AnyObject {
    /// View send product id.
    /// - Parameter id: Product id.
    func viewSendId(_ id: Int)
}

/// View other product.
class OtherProductView: UIView {
    // MARK: - Visual Components

    private lazy var productImage: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = AppStyles.color.background
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = AppStyles.color.incomplete
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = AppStyles.color.text
        label.backgroundColor = AppStyles.color.background
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = AppStyles.color.text
        label.font = .preferredFont(forTextStyle: .body)
        label.backgroundColor = AppStyles.color.background
        return label
    }()

    // MARK: - Public Properties

    /// Delegate view.
    weak var delegate: (AnyObject & OtherProductViewDelegate)?

    // MARK: - Private Properties

    /// Product id.
    private var id: Int?

    // MARK: - Initialization

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setting UI Methods

    /// Settings for the visual part.
    private func setupUI() {
        addSubview(productImage)
        NSLayoutConstraint.activate([
            productImage.topAnchor.constraint(equalTo: topAnchor, constant: AppStyles.size.padding / 2),
            productImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppStyles.size.padding / 2),
            productImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppStyles.size.padding / 2),
            productImage.heightAnchor.constraint(equalTo: widthAnchor)
        ])

        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: productImage.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AppStyles.size.padding / 2 )
        ])

        // Adding a click action.
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(actionView))
        addGestureRecognizer(tapGest)

        // Disabled interaction for empty products.
        isUserInteractionEnabled = false
    }

    // MARK: - Public Methods

    /// Reset the settings for reuse.
    func prepareForReuse() {
        id = nil

        nameLabel.text = nil
        priceLabel.text = nil
        productImage.image = nil

        layer.borderColor = .none
        layer.cornerRadius = 0
        layer.borderWidth = 0

        isUserInteractionEnabled = false
    }

    /// Configure view.
    /// - Parameters:
    ///   - id: Product id.
    ///   - name: Product name.
    ///   - price: Product price.
    ///   - imageData: Product image data.
    func configure(id: Int, name: String, price: Int, imageData: Data?) {
        self.id = id
        nameLabel.text = name
        priceLabel.text = "\(price) ₽"

        if let data = imageData {
            productImage.image = UIImage(data: data)
        }

        layer.borderColor = AppStyles.color.complete.cgColor
        layer.cornerRadius = AppStyles.layer.cornerRadius
        layer.borderWidth = AppStyles.layer.borderWidth.complete

        isUserInteractionEnabled = true
    }

    // MARK: - Actions

    /// Passes the product id.
    @objc private func actionView() {
        guard let id = id else { return }
        delegate?.viewSendId(id)
    }
}
