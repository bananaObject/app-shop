//
//  CatalogViewController.swift
//  shop
//
//  Created by Ke4a on 10.11.2022.
//

import UIKit

/// Delegate controller input.
protocol CatalogViewControllerInput {
    /// Reload data collection view.
    func reloadCollectionView()
    /// Reload data item collection view.
    /// - Parameter indexPaths: Array items index.
    func reloadItems(indexPaths: [IndexPath])
    /// Enable/disable loading animation.
    /// - Parameter isEnable: Loading is enable.
    func loadingAnimation(_ isEnable: Bool)
    /// Update enable button basker.
    func updateButtonBasket()
}

/// Delegate controller output.
protocol CatalogViewControllerOutput {
    /// Maximum page.
    var maxPage: Int { get }
    /// Current page.
    var currentPage: Int { get }
    /// Data catalogs.
    var data: [CatalogCellModel] { get }
    /// Basket is empty.
    var basketIsEmpty: Bool { get }
    
    /// View call a request for data.
    /// - Parameters:
    ///   - page: Page.
    ///   - category: Category product.
    func viewFetchData(page: Int, category: Int?)

    /// View calls to add an item to the cart.
    /// - Parameters:
    ///   - index: Index product.
    ///   - qt: Product Quantity.
    func viewAddProductToCart(_ index: Int, qt: Int)

    /// View call a request for basket data.
    func viewFetchBasket()

    /// View call open screen basket.
    func viewOpenBasket()

    /// View call a open product info.
    /// - Parameter index: Product index.
    func viewOpenProductInfo(_ index: Int)

    /// View send analytic;
    func viewSendAnalytic()

    /// View call a request image data.
    /// - Parameter indexPath: Cell index.
    func viewFetchImage(indexPath: IndexPath)

    /// Get the quantity of the item in the cart.
    /// - Parameter index: Index product.
    /// - Returns: Product Quantity.
    func getQtToBasket(_ index: Int) -> Int
}

class CatalogViewController: UIViewController {
    // MARK: - Visual Components

    /// Screen view.
    private var catalogView: CatalogView {
        guard let view = self.view as? CatalogView else {
            let vc = CatalogView(self)
            self.view = vc
            return vc
        }

        return view
    }

    /// Presenter with screen control.
    private var presenter: CatalogViewControllerOutput

    // MARK: - Initialization

    /// Presenter with screen control.
    /// - Parameter presenter: Presenter with screen control protocol
    init(presenter: CatalogViewControllerOutput) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        self.view = CatalogView(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        catalogView.setupUI()
        setupNavController()
        presenter.viewFetchData(page: 1, category: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false

        // Refresh the basket when they are returned to the screen or on first load.
        presenter.viewFetchBasket()
        presenter.viewSendAnalytic()
    }

    // MARK: - Setting UI Methods

    /// Settings navbar controller.
    private func setupNavController() {
        guard let navBar = navigationController?.navigationBar else { return }

        navigationItem.title = AppDataScreen.catalog.tittleNav

        navBar.tintColor = AppStyles.color.complete
        navBar.backgroundColor = AppStyles.color.background

        // Changes the color of the navbar title
        let textAttributes = [NSAttributedString.Key.foregroundColor: AppStyles.color.complete]
        navBar.titleTextAttributes = textAttributes

        let menuBtn = UIButton(type: .custom)
        menuBtn.setImage(.init(named: AppDataScreen.image.basket), for: .normal)
        menuBtn.addTarget(self, action: #selector(actionBasketButton), for: .touchUpInside)
        menuBtn.imageView?.contentMode = .scaleAspectFit

        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        menuBtn.translatesAutoresizingMaskIntoConstraints = true
        menuBarItem.isEnabled = false
        NSLayoutConstraint.activate([
            menuBtn.heightAnchor.constraint(equalToConstant: navBar.frame.height ),
            menuBtn.widthAnchor.constraint(equalTo: menuBtn.heightAnchor)
        ])
        navigationItem.rightBarButtonItem = menuBarItem
    }

    /// Action basket bar button.
    @objc func actionBasketButton() {
        presenter.viewOpenBasket()
    }

    /// Checking if the cart button should be enabled. If the cart is empty, then the button is disabled.
    private func checkEnableNavBarButtonBasket() {
        guard let button = navigationItem.rightBarButtonItem else { return }

        if presenter.basketIsEmpty && button.isEnabled {
            button.isEnabled = false
        } else if !presenter.basketIsEmpty && !button.isEnabled {
            button.isEnabled = true
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CatalogViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.data.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatalogCollectionViewCell.identifier,
                                                            for: indexPath)
                as? CatalogCollectionViewCell else { preconditionFailure() }

        let product = presenter.data[indexPath.item]
        let qt = presenter.getQtToBasket(indexPath.item)
        cell.configure(name: product.name,
                       price: product.price,
                       index: indexPath.item,
                       quantity: qt,
                       image: product.imageData)
        cell.delegate = self

        if product.imageData == nil {
            presenter.viewFetchImage(indexPath: indexPath)
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CatalogViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.viewOpenProductInfo(indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: (collectionView.frame.width - AppStyles.size.padding * 2) / 2
                      - AppStyles.size.padding * 0.5,
                      height: (collectionView.frame.height - AppStyles.size.padding) / 4
                      - AppStyles.size.padding * 0.5 * 2)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: AppStyles.size.padding, left: AppStyles.size.padding,
              bottom: AppStyles.size.padding, right: AppStyles.size.padding)
    }
}

// MARK: - CatalogCellOutput

extension CatalogViewController: CatalogCellOutput {
    func addProductToCart(index: Int, qt: Int) {
        presenter.viewAddProductToCart(index, qt: qt)
        checkEnableNavBarButtonBasket()
    }
}

// MARK: - CatalogViewControllerInput

extension CatalogViewController: CatalogViewControllerInput {
    func reloadItems(indexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            self.catalogView.reloadItems(indexPaths: indexPaths)
        }
    }

    func loadingAnimation(_ isEnable: Bool) {
        DispatchQueue.main.async {
            self.catalogView.loadingAnimation(isEnable)
        }
    }

    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.catalogView.reloadCollectionView()
        }
    }

    func updateButtonBasket() {
        DispatchQueue.main.async {
            self.checkEnableNavBarButtonBasket()
        }
    }
}
