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

    /// Add product to basket.
    /// - Parameters:
    ///   - index: Index product.
    ///   - qt: Product Quantity.
    func addProductToCart(_ index: Int, qt: Int)

    /// Enable/disable loading animation.
    /// - Parameter isEnable: Loading is enable.
    func loadingAnimation(_ isEnable: Bool)
}

/// Delegate controller output.
protocol CatalogViewControllerOutput {
    /// Maximum page.
    var maxPage: Int { get }
    /// Current page.
    var currentPage: Int { get }
    /// Data catalogs.
    var data: [ResponseProductModel] { get }
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
    private var presenter: CatalogViewControllerOutput?

    // MARK: - Initialization

    /// Presenter with screen control.
    /// - Parameter presenter: Presenter with screen control protocol
    init(presenter: CatalogViewControllerOutput) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
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
        presenter?.viewFetchData(page: 1, category: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false

        // Refresh the basket when they are returned to the screen or on first load.
        presenter?.viewFetchBasket()
        presenter?.viewSendAnalytic()
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
        presenter?.viewOpenBasket()
    }

    /// Checking if the cart button should be enabled. If the cart is empty, then the button is disabled.
    private func setEnableNavBarButtonBasket() {
        guard let button = navigationItem.rightBarButtonItem, let presenter = presenter else { return }

        if presenter.basketIsEmpty && button.isEnabled {
            button.isEnabled = false
        } else if !presenter.basketIsEmpty && !button.isEnabled {
            button.isEnabled = true
        }
    }

    /// Enable basket bar button.
    private func enableBarButton() {
        guard let button = navigationItem.rightBarButtonItem else { return }
        button.isEnabled = true
    }
}

// MARK: - CatalogViewControllerInput

extension CatalogViewController: CatalogViewControllerInput {
    func loadingAnimation(_ isEnable: Bool) {
        DispatchQueue.main.async {
            self.catalogView.loadingAnimation(isEnable)
        }
    }

    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.catalogView.reloadCollectionView()
            self.setEnableNavBarButtonBasket()
        }
    }
}

// MARK: - CatalogViewOutput

extension CatalogViewController: CatalogViewOutput {
    func openProductInfo(_ index: Int) {
        presenter?.viewOpenProductInfo(index)
    }

    func getQtItem(_ index: Int) -> Int {
        presenter?.getQtToBasket(index) ?? 0
    }

    func addProductToCart(_ index: Int, qt: Int) {
        enableBarButton()
        presenter?.viewAddProductToCart(index, qt: qt)
    }

    var data: [ResponseProductModel] {
        presenter?.data ?? []
    }
}
