//
//  ProductImageCell.swift
//  shop
//
//  Created by Ke4a on 15.11.2022.
//

import UIKit

/// A cell with an image slider.
class ProductImageCell: UITableViewCell {
    // MARK: - Visual Components

    /// Slider image.
    private lazy var imageSlider: ImageSlider = {
        let view = ImageSlider()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Static Properties

    /// Сell identifier.
    static var identifier = "ProductImageCell"

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
        contentView.addSubview(imageSlider)
        
        NSLayoutConstraint.activate([
            imageSlider.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageSlider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageSlider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageSlider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    // MARK: - Public Methods

    /// Configure cell.
    /// - Parameter images: Array image.
    func configure(_ images: [UIImage]) {
        imageSlider.setImages(images)
    }
}
