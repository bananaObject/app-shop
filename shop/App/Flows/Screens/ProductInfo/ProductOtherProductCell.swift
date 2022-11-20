//
//  ProductOtherProductCell.swift
//  shop
//
//  Created by Ke4a on 16.11.2022.
//

import UIKit

/// Cell with other products.
class ProductOtherProductCell: UITableViewCell {
    // MARK: - Visual Components

    /// Stack other products.
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = AppStyles.size.padding
        stack.backgroundColor = AppStyles.color.background
        stack.distribution = .fillEqually
        return stack
    }()

    // MARK: - Static Properties

    /// Сell identifier.
    static var identifier = "ProductOtherProductCell"

    // MARK: - Public Properties

    /// The  delegate view.
    weak var delegate: (AnyObject & ProductInfoViewOutput)?

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Prepare For Reuse

    override func prepareForReuse() {
        super.prepareForReuse()

        stack.arrangedSubviews.forEach { view in
            guard let otherView = view as? OtherProductView else { return }
            otherView.prepareForReuse()
        }
    }

    // MARK: - Setting UI Methods

    /// Settings for the visual part.
    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppStyles.size.padding / 2),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        // The number of products in the cell.
        for _ in 0..<AppDataScreen.productInfo.qtInCellOtherProducts {
            let view = OtherProductView()
            view.delegate = self
            stack.addArrangedSubview(view)
        }
    }

    // MARK: - Public Methods

    /// Configure cell.
    /// - Parameter products: Other product.
    func configure(_ products: [ResponseProductModel]) {
        stack.arrangedSubviews.enumerated().forEach { index, view in
            guard let otherView = view as? OtherProductView else { return }

            // If there is a product for this index, then fill it.
            if products.indices.contains(index) {
                let product = products[index]
                otherView.configure(id: product.id, name: product.name, price: product.price, image: UIImage())
            }
        }
    }
}

// MARK: - OtherProductItemViewOutput

extension ProductOtherProductCell: OtherProductViewDelegate {
    func viewSendId(_ id: Int) {
        delegate?.viewSendId(id)
    }
}
