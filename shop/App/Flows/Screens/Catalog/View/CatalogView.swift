//
//  CatalogView.swift
//  shop
//
//  Created by Ke4a on 10.11.2022.
//

import UIKit

/// View delegate output.
protocol CatalogViewOutput {
    /// Request response data when there is no response is an empty array.
    var data: [ResponseProductModel] { get }

    /// Number of items in the cart.
    /// - Parameter index: Product index.
    /// - Returns: Product quantity.
    func getQtItem(_ index: Int) -> Int
    
    /// Adds  product to basket  by index.
    /// - Parameter index: Index product in collection.
    /// - Parameter qt: Product quantity added to cart.
    func addProductToCart(_ index: Int, qt: Int)
}

/// View "Catalog".
class CatalogView: UIView {
    // MARK: - Visual Components

    /// Loading view.
    private lazy var loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// Collection view catalog.
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setCollectionViewLayout(layout, animated: true)
        view.backgroundColor = AppStyles.color.background
        return view
    }()

    /// Layout catalog.
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = AppStyles.size.padding
        layout.minimumLineSpacing = AppStyles.size.padding
        layout.scrollDirection = .vertical
        return layout
    }()

    // MARK: - Private Properties

    /// The controller that manages the view.
    private weak var controller: (AnyObject & CatalogViewOutput)?

    // MARK: - Initialization

    /// Init catalog view.
    /// - Parameter controller: The controller that manages the view.
    init(_ controller: UIViewController & CatalogViewOutput) {
        super.init(frame: .zero)
        self.controller = controller

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(CatalogCollectionViewCell.self,
                                forCellWithReuseIdentifier: CatalogCollectionViewCell.identifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setting UI Methods

    /// Settings for the visual part.
    func setupUI() {
        backgroundColor = .white

        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                                constant: AppStyles.size.padding),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                                   constant: -AppStyles.size.padding),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                    constant: AppStyles.size.padding),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                     constant: -AppStyles.size.padding)
        ])

        addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor)
        ])
    }

    // MARK: - Private Methods

    /// Reload data collectionView
    func reloadCollectionView() {
        collectionView.reloadData()
    }

    /// Enable/disable loading animation.
    /// - Parameter isEnable: Loading is enable.
    func loadingAnimation(_ isEnable: Bool) {
        loadingView.animation(isEnable)
    }
}

// MARK: - UICollectionViewDataSource

extension CatalogView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        controller?.data.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatalogCollectionViewCell.identifier,
                                                            for: indexPath)
                as? CatalogCollectionViewCell else { preconditionFailure() }

        if let product = controller?.data[indexPath.item] {
            let qt = controller?.getQtItem(indexPath.item)

            cell.configure(name: product.name, price: product.price, index: indexPath.item, quantity: qt)
            cell.delegate = self
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CatalogView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.5 - AppStyles.size.padding * 0.5,
                      height: collectionView.frame.width * 0.5 - AppStyles.size.padding * 0.5)
    }
}

// MARK: - CatalogCellOutput

extension CatalogView: CatalogCellOutput {
    func addProductToCart(index: Int, qt: Int) {
        controller?.addProductToCart(index, qt: qt)
    }
}
