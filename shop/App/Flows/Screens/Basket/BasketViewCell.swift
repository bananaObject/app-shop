//
//  BasketViewCell.swift
//  shop
//
//  Created by Ke4a on 22.11.2022.
//

import UIKit

protocol BasketViewCellDelegate: AnyObject {
    /// View sent a new quantity of product.
    /// - Parameters:
    ///   - id: Product id.
    ///   - qt: Product quantity.
    func viewSendNewQtProduct(id: Int, qt: Int)
}

/// Basket cell.
class BasketViewCell: UITableViewCell {
    // MARK: - Visual Components

    private lazy var productImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.borderWidth = AppStyles.layer.borderWidth.complete
        view.layer.cornerRadius = AppStyles.layer.cornerRadius
        view.layer.borderColor = AppStyles.color.main.cgColor
        return view
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: AppDataScreen.image.cross)
        button.setImage(image, for: .normal)
        button.tintColor = AppStyles.color.main
        return button
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 26, weight: .medium)
        label.textColor = AppStyles.color.text
        label.textAlignment = .natural
        return label
    }()

    private lazy var qtView: QtView = {
        let view = QtView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .light)
        label.textAlignment = .center
        label.textColor = AppStyles.color.text
        return label
    }()

    /// Cell delegate.
    weak var delegate: (AnyObject & BasketViewCellDelegate)?

    /// Product id.
    private var id: Int?

    /// Product quantity.
    private var qt: Int = 0

    // MARK: - Static Properties

    /// Сell identifier.
    static var identifier = "BasketViewCell"

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
        
        contentView.addSubview(productImageView)
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                  constant: AppStyles.size.padding),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                     constant: -AppStyles.size.padding),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                      constant: AppStyles.size.padding),
            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor)
        ])

        contentView.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                   constant: -AppStyles.size.padding),
            deleteButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.25),
            deleteButton.widthAnchor.constraint(equalTo: deleteButton.heightAnchor)
        ])

        deleteButton.addTarget(self, action: #selector(actionRemoveProduct), for: .touchUpInside)
        
        contentView.addSubview(qtView)
        NSLayoutConstraint.activate([
            qtView.trailingAnchor.constraint(equalTo: deleteButton.trailingAnchor),
            qtView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            qtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
            qtView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3)
        ])

        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor,
                                               constant: AppStyles.size.padding),
            nameLabel.trailingAnchor.constraint(equalTo: qtView.leadingAnchor),
            nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor,
                                              multiplier: 0.5)
        ])

        contentView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])

        qtView.setLimits(1, 25)
        qtView.addTarget(self, actionAdd: #selector(actionAddItem), actionRemove: #selector(actionRemoveItem))
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        productImageView.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
    }

    // MARK: - Public Methods

    /// Confirure cell.
    func configure(_ item: BasketViewCellModel) {
        nameLabel.text = item.name
        if let formatString = item.price.formatThousandSeparator() {
            priceLabel.text = "\(formatString) ₽"
        } else {
            priceLabel.text = "\(item.price) ₽"
        }
        if let data = item.imageData {
            productImageView.image = UIImage(data: data)
        }

        productImageView.tintColor = AppStyles.color.main
        self.id = item.id
        setQt(qt: item.quantity, sendRequest: false)
    }

    // MARK: - Private Methods

    /// Set quantity in cell.
    /// - Parameter qt: Product quantity.
    /// - Parameter sendRequest: Send result to api.
    private func setQt(qt: Int, sendRequest: Bool) {
        self.qt = qt >= 1 ? qt : 1
        qtView.setQt(qt)

        if sendRequest {
            NSObject.cancelPreviousPerformRequests(
                withTarget: self as Any,
                selector: #selector(actionDebounceSendRequest),
                object: nil)
            perform(#selector(actionDebounceSendRequest), with: nil, afterDelay: 0.3)
        }
    }

    // MARK: - Actions

    /// Action add item in basket.
    @objc private func actionAddItem() {
        self.qt += 1
        setQt(qt: self.qt, sendRequest: true)
    }

    /// Action remove item from basket.
    @objc private func actionRemoveItem() {
        self.qt -= 1
        setQt(qt: self.qt, sendRequest: true)
    }

    /// Action remove product from basket.
    @objc private func actionRemoveProduct() {
        guard let id = self.id else { return }
        delegate?.viewSendNewQtProduct(id: id, qt: 0)
    }

    /// Action debounce send request.
    @objc private func actionDebounceSendRequest() {
        guard let id = self.id else { return }
        delegate?.viewSendNewQtProduct(id: id, qt: qt)
    }
}
