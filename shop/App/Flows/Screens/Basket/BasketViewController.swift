//
//  BasketViewController.swift
//  shop
//
//  Created by Ke4a on 22.11.2022.
//

import UIKit

/// View controller "Basket"  input protocol.
protocol BasketViewControllerInput {
    /// Reload data table view.
    func reloadTableView()

    /// Delete row table view.
    /// - Parameter index: Index cell.
    func deleteRowTableView(_ index: IndexPath)

    /// Delete all rows table view.
    func deleteAllRows()

    /// Show result payment.
    /// - Parameter text: Result text/
    func showPaymentAlert(_ text: String)

    /// Enable/disable loading animation.
    /// - Parameter isEnable: Loading is enable.
    func loadingAnimation(_ isEnable: Bool)

    /// Stop show loading indicator.
    func stopLoadingIndicatorButton()

    /// Adding a button to the navbar. Disable the button if the cart is empty.
    /// - Parameter basketIsEmpty: Basket is empty.
    func setTrashButton(_ basketIsEmpty: Bool)

    /// Update new sum total cost.
    func updateTotalCost()
}

/// View controller "Basket"  output protocol.
protocol BasketViewControllerOutput {
    /// Basket data.
    var data: [BasketViewCellModel] { get }

    ///  Total amount all product in basket.
    var totalCost: Int { get }

    /// View requested information about the basket.
    /// - Parameter loadingAnimation: Loading animation/
    func viewRequestedBasket(_ loadingAnimation: Bool)

    /// View requests to remove all items in the basket.
    func viewRequestedToEmptyBasket()

    /// View sent a new quantity of product.
    /// - Parameters:
    ///   - id: Product id.
    ///   - qt: Product quantity.
    func viewSendNewQtProduct(id: Int, qt: Int)

    /// View requested information about the basket.
    func viewRequestPayment()

    /// View call a request image data.
    /// - Parameter indexPath: Cell index.
    func viewFetchImage(indexPath: IndexPath)
}

/// "Basket" screen with presenter.
class BasketViewController: UIViewController {
    // MARK: - Visual Components

    /// Screen view.
    private var basketView: BasketView {
        guard let view = self.view as? BasketView else {
            let vc = BasketView(self)
            self.view = vc
            return vc
        }

        return view
    }

    private lazy var activityIndicator: UIBarButtonItem = {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let barButton = UIBarButtonItem(customView: activityIndicator)
        return barButton
    }()

    private lazy var trashButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashAction))
        button.tintColor = .red
        button.isEnabled = false
        return button
    }()

    // MARK: - Private Properties

    /// Presenter with screen control.
    private var presenter: BasketViewControllerOutput

    // MARK: - Initialization
    
    /// Presenter with screen control.
    /// - Parameter presenter: Presenter with screen control protocol.
    init(presenter: BasketViewControllerOutput) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        self.view = BasketView(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavController()
        basketView.setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewRequestedBasket(true)
    }

    // MARK: - Setting UI Methods

    /// Settings navbar controller.
    private func setupNavController() {
        navigationItem.title = AppDataScreen.basket.tittleNav

        navigationController?.navigationBar.tintColor = AppStyles.color.main
        navigationController?.navigationBar.backgroundColor = AppStyles.color.background

        // Changes the color of the navbar title
        let textAttributes = [NSAttributedString.Key.foregroundColor: AppStyles.color.main]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

        navigationItem.rightBarButtonItem = trashButton
    }

    // MARK: - Private Methods

    /// Adding activity indicator to the navbar.
    /// - Parameter basketIsEmpty: Basket is empty.
    private func setActivityIndicator() {
        navigationItem.rightBarButtonItem = activityIndicator
        let indicator = activityIndicator.customView as? UIActivityIndicatorView
        indicator?.startAnimating()
    }

    // MARK: - Actions

    /// Action trash button.
    @objc private func trashAction() {
        setActivityIndicator()
        presenter.viewRequestedToEmptyBasket()
    }
}

// MARK: - BasketViewControllerInput

extension BasketViewController: BasketViewControllerInput {
    func deleteAllRows() {
        DispatchQueue.main.async {
            self.basketView.deleteAllCell()
        }
    }

    func updateTotalCost() {
        DispatchQueue.main.async {
            self.basketView.updateTotalCost()
        }
    }

    func loadingAnimation(_ isEnable: Bool) {
        DispatchQueue.main.async {
            self.basketView.loadingAnimation(isEnable)
        }
    }

    func setTrashButton(_ basketIsEmpty: Bool) {
        navigationItem.rightBarButtonItem = trashButton
        navigationItem.rightBarButtonItem?.isEnabled = !basketIsEmpty
    }

    func stopLoadingIndicatorButton() {
        DispatchQueue.main.async {
            self.basketView.stopLoadingIndicatorButton()
        }
    }

    func showPaymentAlert(_ text: String) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            alert.dismiss(animated: true)
        }
    }

    func deleteRowTableView(_ index: IndexPath) {
        DispatchQueue.main.async {
            self.basketView.deleteRowTableView(index)
        }
    }

    func reloadTableView() {
        DispatchQueue.main.async {
            self.basketView.reloadTableView()
        }
    }
}

// MARK: - BasketViewOutput

extension BasketViewController: BasketViewOutput {
    func viewRequestPayment() {
        presenter.viewRequestPayment()
    }

    var totalCost: Int {
        presenter.totalCost
    }

    func viewRefreshData() {
        presenter.viewRequestedBasket(false)
    }

    var data: [BasketViewCellModel] {
        presenter.data
    }
}

extension BasketViewController: BasketViewCellDelegate {
    func viewSendNewQtProduct(id: Int, qt: Int) {
        presenter.viewSendNewQtProduct(id: id, qt: qt)
    }
}

// MARK: - UITableViewDelegate

extension BasketViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.frame.height / AppDataScreen.basket.cellOnscreen
    }
}

// MARK: - UITableViewDataSource

extension BasketViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BasketViewCell.identifier, for: indexPath)
                as? BasketViewCell else { preconditionFailure() }
        let product = presenter.data[indexPath.row]
        if product.imageData == nil {
            self.presenter.viewFetchImage(indexPath: indexPath)
        }

        if cell.delegate == nil {
            cell.delegate = self
        }

        cell.configure(product)

        return cell
    }
}
