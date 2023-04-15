//
//  CatalogView.swift
//  shop
//
//  Created by Ke4a on 10.11.2022.
//

import UIKit

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

    // MARK: - Initialization

    /// Init catalog view.
    /// - Parameter controller: The controller that manages the view.
    init(_ controller: AnyObject
         & UICollectionViewDelegateFlowLayout
         & UICollectionViewDataSource
         & UICollectionViewDataSourcePrefetching) {
        super.init(frame: .zero)

        collectionView.prefetchDataSource = controller
        collectionView.dataSource = controller
        collectionView.delegate = controller

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
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])

        addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor)
        ])

        setUITests()
    }

    // MARK: - Public Methods

    /// Reload data collectionView
    func reloadCollectionView() {
        collectionView.reloadData()
    }
    /// Reload data item collectionView
    /// - Parameter indexPaths: Array items index.
    func reloadItems(indexPaths: [IndexPath]) {
        collectionView.reloadItems(at: indexPaths)
    }

    func insertItems(indexPaths: [IndexPath]) {
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: indexPaths)
        }
    }

    /// Enable/disable loading animation.
    /// - Parameter isEnable: Loading is enable.
    func loadingAnimation(_ isEnable: Bool) {
        loadingView.animation(isEnable)
    }

    // MARK: - Private Methods

    /// Set identifier for components.
    private func setUITests() {
        self.accessibilityIdentifier = "catalogView"
    }
}
