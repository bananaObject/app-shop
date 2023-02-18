//
//  ProductReviewCell.swift
//  shop
//
//  Created by Ke4a on 15.11.2022.
//

import UIKit

/// Cell with a review and a "more reviews" button
class ProductReviewCell: UITableViewCell {
    // MARK: - Visual Components

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Последний отзыв:"
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = AppStyles.color.complete
        label.textAlignment = .center

        return label
    }()

    private lazy var reviewBox: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = AppStyles.layer.cornerRadius
        view.layer.borderWidth = AppStyles.layer.borderWidth.incomplete
        view.layer.borderColor = AppStyles.color.incomplete.cgColor
        return view
    }()

    private lazy var moreReviewsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("more reviews", for: .normal)
        button.setTitleColor(AppStyles.color.background, for: .normal)
        button.backgroundColor = AppStyles.color.complete
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        button.layer.cornerRadius = AppStyles.layer.cornerRadius
        button.layer.borderWidth = AppStyles.layer.borderWidth.incomplete
        button.layer.borderColor = AppStyles.color.incomplete.cgColor
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        return button
    }()

    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppStyles.color.complete
        return label
    }()

    private lazy var reviewTextLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 6
        label.textColor = AppStyles.color.text
        return label
    }()

    private lazy var fullTextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Show full text", for: .normal)
        button.setTitleColor(AppStyles.color.main, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Static Properties

    /// Сell identifier.
    static var identifier = "ProductReviewCell"

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
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])

        contentView.addSubview(reviewBox)
        NSLayoutConstraint.activate([
            reviewBox.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                           constant: AppStyles.size.padding),
            reviewBox.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            reviewBox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            reviewBox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        reviewBox.addSubview(usernameLabel)
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: reviewBox.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: reviewBox.leadingAnchor,
                                                   constant: AppStyles.size.padding * 2),
            usernameLabel.trailingAnchor.constraint(equalTo: reviewBox.trailingAnchor)
        ])

        reviewBox.addSubview(moreReviewsButton)
        NSLayoutConstraint.activate([
            moreReviewsButton.topAnchor.constraint(equalTo: reviewBox.topAnchor),
            moreReviewsButton.trailingAnchor.constraint(equalTo: reviewBox.trailingAnchor),
            moreReviewsButton.heightAnchor.constraint(equalTo: usernameLabel.heightAnchor)
        ])

        reviewBox.addSubview(reviewTextLabel)
        NSLayoutConstraint.activate([
            reviewTextLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor,
                                                 constant: AppStyles.size.padding / 2),
            reviewTextLabel.leadingAnchor.constraint(equalTo: reviewBox.leadingAnchor,
                                                     constant: AppStyles.size.padding),
            reviewTextLabel.trailingAnchor.constraint(equalTo: reviewBox.trailingAnchor,
                                                      constant: -AppStyles.size.padding)
        ])

        reviewBox.addSubview(fullTextButton)
        NSLayoutConstraint.activate([
            fullTextButton.topAnchor.constraint(equalTo: reviewTextLabel.bottomAnchor),
            fullTextButton.bottomAnchor.constraint(equalTo: reviewBox.bottomAnchor),
            fullTextButton.leadingAnchor.constraint(equalTo: reviewTextLabel.leadingAnchor)
        ])

        fullTextButton.addTarget(self, action: #selector(showFullTextAction), for: .touchUpInside)
    }

    // MARK: - Public Methods

    /// Configure cell.
    /// - Parameter review: Last product review.
    func configure(review: ResponseReviewModel) {
        usernameLabel.text = review.userName
        reviewTextLabel.text = review.text
        checMoreButton(review.text)
    }

    // MARK: - Private Methods

    /// Checking if the button "show all text" is needed.
    /// - Parameter text: Review text.
    private func checMoreButton(_ text: String) {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))

        let text = text as NSString
        let textHeight = text.boundingRect(
            with: maxSize,
            options: .usesLineFragmentOrigin,
            attributes: [.font: reviewTextLabel.font as Any],
            context: nil).height
        let lineHeight = reviewTextLabel.font.lineHeight

        // If the text is small, then delete the button and change the constraint.
        if ceil(textHeight / lineHeight) < CGFloat(reviewTextLabel.numberOfLines) {
            NSLayoutConstraint.activate([
                reviewTextLabel.bottomAnchor.constraint(equalTo: reviewBox.bottomAnchor,
                                                        constant: -AppStyles.size.padding)
            ])
            fullTextButton.removeFromSuperview()
        }
    }

    // MARK: - Actions

    /// Action show full text.
    @objc private func showFullTextAction() {
        guard let tableView = superview as? UITableView else { return }

        tableView.beginUpdates()
        reviewTextLabel.numberOfLines = 0
        NSLayoutConstraint.activate([
            reviewTextLabel.bottomAnchor.constraint(equalTo: reviewBox.bottomAnchor, constant: -AppStyles.size.padding)
        ])
        fullTextButton.removeFromSuperview()
        tableView.endUpdates()
    }
}
