//
//  ProductDescriptionCell.swift
//  shop
//
//  Created by Ke4a on 16.11.2022.
//

import UIKit

/// Cell with product description.
class ProductDescriptionCell: UITableViewCell {
    // MARK: - Visual Components

    private lazy var textDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.textColor = AppStyles.color.text
        label.backgroundColor = AppStyles.color.background
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.lineBreakMode = .byClipping
        return label
    }()

    // MARK: - Static Methods

    /// Сell identifier.
    static var identifier = "ProductDescriptionCell"

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
        contentView.addSubview(textDescriptionLabel)

        NSLayoutConstraint.activate([
            textDescriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            textDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                          constant: AppStyles.size.padding),
            textDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                           constant: -AppStyles.size.padding)
        ])
    }

    // MARK: - Public Methods

    /// Configure cell.
    /// - Parameter text: Product description.
    func configure(_ text: String) {
        textDescriptionLabel.text = text
    }
}
