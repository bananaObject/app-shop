//
//  BasketView.swift
//  shop
//
//  Created by Ke4a on 22.11.2022.
//

import UIKit

/// View protocol output.
protocol BasketViewOutput {
    /// Basket data.
    var data: [ResponseBasketModel] { get }
    ///  Total amount all product in basket.
    var totalCost: Int { get }

    /// View sent a new quantity of product.
    /// - Parameters:
    ///   - id: Product id.
    ///   - qt: Product quantity.
    func viewSendNewQtProduct(id: Int, qt: Int)
    /// Updata data
    func viewRefreshData()
    /// View requested information about the basket.
    func viewRequestPayment()
}

/// View "Basket" screen.
class BasketView: UIView {
    // MARK: - Visual Components

    private lazy var loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var payButton: AppButton = {
        let button = AppButton(tittle: "Pay", activityIndicator: true)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font =  .preferredFont(forTextStyle: .title1)
        button.setIsEnable(enable: false)
        return button
    }()

    private lazy var totalCostLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = AppStyles.color.text
        label.font = .preferredFont(forTextStyle: .largeTitle)
        return label
    }()

    // MARK: - Private Properties

    /// The controller that manages the view.
    private weak var controller: (UIViewController & BasketViewOutput)?

    // MARK: - Initialization

    /// Init basket view.
    /// - Parameter controller: The controller that manages the view.
    init(_ controller: UIViewController & BasketViewOutput) {
        super.init(frame: .zero)
        self.controller = controller
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setting UI Methods

    /// Settings for the visual part.
    func setupUI() {
        setTotalCost(0)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(BasketViewCell.self, forCellReuseIdentifier: BasketViewCell.identifier)

        backgroundColor = AppStyles.color.background

        let footer = UIView()
        footer.translatesAutoresizingMaskIntoConstraints = false
        footer.backgroundColor = AppStyles.color.lightGray

        addSubview(footer)
        NSLayoutConstraint.activate([
            footer.bottomAnchor.constraint(equalTo: bottomAnchor),
            footer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            footer.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            footer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.20)
        ])

        footer.addSubview(totalCostLabel)
        NSLayoutConstraint.activate([
            totalCostLabel.topAnchor.constraint(equalTo: footer.topAnchor,
                                                constant: AppStyles.size.padding ),
            totalCostLabel.leadingAnchor.constraint(equalTo: footer.leadingAnchor),
            totalCostLabel.trailingAnchor.constraint(equalTo: footer.trailingAnchor)
        ])

        footer.addSubview(payButton)
        NSLayoutConstraint.activate([
            payButton.topAnchor.constraint(equalTo: totalCostLabel.bottomAnchor,
                                           constant: AppStyles.size.padding),
            payButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                              constant: -AppStyles.size.padding),
            payButton.leadingAnchor.constraint(equalTo: footer.leadingAnchor,
                                               constant: AppStyles.size.padding * 2),
            payButton.trailingAnchor.constraint(equalTo: footer.trailingAnchor,
                                                constant: -AppStyles.size.padding * 2)
        ])

        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: footer.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])

        addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: tableView.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor)
        ])
        
        setupRefreshControl()
        payButton.addTarget(self, action: #selector(payButtonAction), for: .touchUpInside)
    }

    /// Settings refresh control.
    private func setupRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = AppStyles.color.main
        tableView.refreshControl?.addTarget(self, action: #selector(refreshControlAction),
                                            for: .valueChanged)
    }

    // MARK: - Public Methods

    /// Reload data table view.
    func reloadTableView() {
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
        checkPayButton()
        setTotalCost(controller?.totalCost ?? 0)
    }

    /// Delete row table view.
    /// - Parameter index: Index cell.
    func deleteRowTableView(_ index: IndexPath) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [index], with: .left)
        tableView.endUpdates()
        checkPayButton()
        setTotalCost(controller?.totalCost ?? 0)
    }

    /// Enable/disable loading animation.
    /// - Parameter isEnable: Loading is enable.
    func loadingAnimation(_ isEnable: Bool) {
        loadingView.animation(isEnable)
    }

    /// Stop show loading indicator.
    func stopLoadingIndicatorButton() {
        payButton.showLoadingIndicator(false)
    }

    /// Set total amount.
    /// - Parameter sum: Sum all product.
    func setTotalCost(_ sum: Int) {
        guard let formatString = sum.formatThousandSeparator() else { return }
        totalCostLabel.text = formatString + " ₽"
    }

    /// Update new sum total cost.
    func updateTotalCost() {
        setTotalCost(controller?.totalCost ?? 0)
    }
    /// Show result payment.
    /// - Parameter text: Result text/
    func showPaymentAlert(_ text: String) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        controller?.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            alert.dismiss(animated: true)
        }
    }

    // MARK: - Private Methods

    /// Checking the cart for emptiness. If empty, payment is not available.
    private func checkPayButton() {
        if controller?.data.isEmpty == false && payButton.isEnabled == false {
            payButton.setIsEnable(enable: true)
        } else if controller?.data.isEmpty == true && payButton.isEnabled == true {
            payButton.setIsEnable(enable: false)
        }
    }

    // MARK: - Actions

    /// Action regresh control. Starts the loading animation and data request.
    @objc private func refreshControlAction() {
        self.tableView.refreshControl?.beginRefreshing()
        controller?.viewRefreshData()
    }

    /// Action pay button. Present payment ste.
    @objc private func payButtonAction() {
        payButton.clickAnimation()
        payButton.showLoadingIndicator(true)

        controller?.viewRequestPayment()
    }
}

// MARK: - UITableViewDelegate

extension BasketView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.frame.height / AppDataScreen.basket.cellOnscreen
    }
}

// MARK: - UITableViewDataSource

extension BasketView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        controller?.data.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BasketViewCell.identifier, for: indexPath)
                as? BasketViewCell else { preconditionFailure() }
        if let product = controller?.data[indexPath.row] {
            cell.configure(product)
            cell.delegate = controller
        }

        return cell
    }
}
