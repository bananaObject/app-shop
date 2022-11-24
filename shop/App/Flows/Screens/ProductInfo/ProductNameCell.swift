//
//  ProductNameCell.swift
//  shop
//
//  Created by Ke4a on 15.11.2022.
//

import UIKit

/// Cell with the name of the product.
class ProductNameCell: UITableViewCell {
    // MARK: - Visual Components

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppStyles.font.tittle
        label.textColor = AppStyles.color.text
        label.backgroundColor = AppStyles.color.background
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    // MARK: - Static Properties
    
    /// Сell identifier.
    static var identifier = "ProductNameCell"

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setting UI Methods

    /// Settings for the visual part.
    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    // MARK: - Public Methods

    /// Configure cell.
    /// - Parameter name: Product name.
    func configure(_ name: String) {
        nameLabel.text = name
    }
}
