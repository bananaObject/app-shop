//
//  ProductInfoView.swift
//  shop
//
//  Created by Ke4a on 13.11.2022.
//

import UIKit

/// View delegate output.
protocol ProductInfoViewOutput {
    /// Product info.
    var getDataInfo: ResponseProductModel? { get }
    /// Section screen. The table is built on this data.
    var getSections: [AppDataScreen.productInfo.Сomponent] { get }
    /// Other product.
    var getOtherProducts: [[ResponseProductModel]] { get }
    /// Product quantity.
    var qtProduct: Int { get set }
    
    /// View sent the id of the product to be opened.
    /// - Parameter id: Product id.
    func viewSendId(_ id: Int)

    /// View send error;
    /// - Parameter error: Error.
    func viewSendError(_ error: ErrorForAnalytic)
}

class ProductInfoView: UIView {
    // MARK: - Visual Components

    private lazy var loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorStyle = .none
        return view
    }()

    private lazy var footer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppStyles.color.background
        return view
    }()

    private lazy var qtView: QtView = {
        let view = QtView()
        view.isFillButton = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Private Properties

    /// The controller that manages the view.
    private weak var controller: (AnyObject & ProductInfoViewOutput)?
    private var qt: Int?

    // MARK: - Initialization

    /// Init product info view.
    /// - Parameter controller: The controller that manages the view.
    init(_ controller: UIViewController & ProductInfoViewOutput) {
        super.init(frame: .zero)
        self.controller = controller
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setting UI Methods

    /// Settings for the visual part.
    func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        registerCell()
        
        backgroundColor = AppStyles.color.background
        tableView.showsVerticalScrollIndicator = false

        addSubview(footer)
        NSLayoutConstraint.activate([
            footer.bottomAnchor.constraint(equalTo: bottomAnchor),
            footer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            footer.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            footer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.12)
        ])

        footer.addSubview(qtView)
        NSLayoutConstraint.activate([
            qtView.centerYAnchor.constraint(equalTo: footer.centerYAnchor),
            qtView.centerXAnchor.constraint(equalTo: footer.centerXAnchor),
            qtView.widthAnchor.constraint(equalTo: footer.widthAnchor, multiplier: 0.8),
            qtView.heightAnchor.constraint(equalTo: footer.heightAnchor, multiplier: 0.6)
        ])
        qtView.addTarget(self, actionAdd: #selector(addProductAction), actionRemove: #selector(removeProductAction))

        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: footer.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                               constant: AppStyles.size.padding),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                constant: -AppStyles.size.padding)
        ])

        addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    /// Registration cell.
    private func registerCell() {
        tableView.register(ProductImageCell.self,
                           forCellReuseIdentifier: ProductImageCell.identifier)
        tableView.register(ProductNameCell.self,
                           forCellReuseIdentifier: ProductNameCell.identifier)
        tableView.register(ProductReviewCell.self,
                           forCellReuseIdentifier: ProductReviewCell.identifier)
        tableView.register(ProductDescriptionCell.self,
                           forCellReuseIdentifier: ProductDescriptionCell.identifier)
        tableView.register(ProductOtherProductCell.self,
                           forCellReuseIdentifier: ProductOtherProductCell.identifier)
    }

    // MARK: - Public Methods

    /// Update all section on screen.
    func updateAllInfoOnScreen() {
        tableView.reloadData()
        self.qt = controller?.qtProduct

        updateQt(false)
    }

    /// Update  section other product  on screen.
    func updateOtherProductsOnScreen() {
        guard let index = controller?.getSections.firstIndex(where: { component in
            switch component {
            case .otherProducts:
                return true
            case .info:
                return false
            }
        }) else { return }
        tableView.reloadSections([index], with: .top)
    }

    /// Enable/disable loading animation.
    /// - Parameter isEnable: Loading is enable.
    func loadingAnimation(_ isEnable: Bool) {
        loadingView.animation(isEnable)
    }

    // MARK: - Private Methods

    /// Select a cell depending on which section it is in.
    /// - Parameter indexPath: Index.
    /// - Returns: Table cell.
    private func selectCell(_ indexPath: IndexPath) -> UITableViewCell {
        let info = controller?.getDataInfo
        let section = controller?.getSections[indexPath.section]

        switch section {
        case .info(let components) where components[indexPath.row] == .images:
            guard let newCell = tableView.dequeueReusableCell( withIdentifier: ProductImageCell.identifier,
                                                               for: indexPath )
                    as? ProductImageCell else {
                return sendError("No ProductImageCell",
                                 "selectCell",
                                 UITableViewCell.self
                )
            }

            // Stub pictures.
            let images: [UIImage] = [.init(named: "catalogProduct")!,
                                     .init(named: "signUp")!,
                                     .init(named: "catalogProduct")!,
                                     .init(named: "catalogProduct")!,
                                     .init(named: "signUp")!,
                                     .init(named: "signUp")!,
                                     .init(named: "catalogProduct")!]
            newCell.configure(images)
            return newCell
        case .info(let components) where components[indexPath.row] == .productName:
            guard let newCell = tableView.dequeueReusableCell( withIdentifier: ProductNameCell.identifier,
                                                               for: indexPath )
                    as? ProductNameCell else {
                return sendError("No ProductNameCell",
                                 "selectCell",
                                 UITableViewCell.self
                )
            }

            newCell.configure(info?.name ?? "##Error")
            return newCell
        case .info(let components) where components[indexPath.row] == .description:
            guard let newCell = tableView.dequeueReusableCell( withIdentifier: ProductDescriptionCell.identifier,
                                                               for: indexPath )
                    as? ProductDescriptionCell else {
                return sendError("No ProductDescriptionCell",
                                 "selectCell",
                                 UITableViewCell.self
                )
            }

            newCell.configure(info?.description ?? "##Error##")
            return newCell
        case .info(let components) where components[indexPath.row] == .review:
            guard let newCell = tableView.dequeueReusableCell( withIdentifier: ProductReviewCell.identifier,
                                                               for: indexPath )
                    as? ProductReviewCell else {
                return sendError("No ProductReviewCell",
                                 "selectCell",
                                 UITableViewCell.self
                )
            }
            guard let review = info?.lastReview else {
                return UITableViewCell()
            }

            newCell.configure(review: review)
            return newCell
        case .otherProducts:
            guard let otherProducts = controller?.getOtherProducts[indexPath.row] else {
                return UITableViewCell()
            }
            
            guard let newCell = tableView.dequeueReusableCell( withIdentifier: ProductOtherProductCell.identifier,
                                                               for: indexPath)
                    as? ProductOtherProductCell else {
                return sendError("No ProductOtherProductCell",
                                 "selectCell",
                                 UITableViewCell.self
                )
            }
            newCell.delegate = self.controller
            newCell.configure(otherProducts)
            return newCell
        default:
            return UITableViewCell()
        }
    }

    /// Update qt info on view.
    /// - Parameter sendQt: Fetch quantity on server.
    private func updateQt(_ sendQt: Bool) {
        guard let qt = self.qt else { return }
        qtView.setQt(qt)

        // Devounce function
        if sendQt {
            NSObject.cancelPreviousPerformRequests(
                withTarget: self as Any,
                selector: #selector(actionDebounce),
                object: nil)
            perform(#selector(actionDebounce), with: nil, afterDelay: 0.5)
        }
    }

    /// Send analytics in case of error.
    /// - Parameters:
    ///   - message: Message error.
    ///   - method: Method.
    /// - Returns: Optional component.
    private func sendError<T: Any>(_ message: String, _ method: String, _ component: T.Type?) -> T {
            #if DEBUG
                    preconditionFailure(message)
            #else
                    controller?.viewSendError(.init(error: message,
                                                    method: method,
                                                    message: nil))
                    return T
            #endif
    }


    /// Send analytics in case of error.
    /// - Parameters:
    ///   - message: Message error.
    ///   - method: Method.
    private func sendError(_ message: String, _ method: String) {
            #if DEBUG
                    preconditionFailure(message)
            #else
                    controller?.viewSendError(.init(error: message,
                                                    method: method,
                                                    message: nil))
            #endif
    }

    /// Adding a new quantity of goods to the cart
    @objc private  func actionDebounce() {
        guard let qt = self.qt else { return }
        controller?.qtProduct = qt
    }

    /// Action add product.
    @objc private func addProductAction() {
        guard let qt = self.qt else { return }
        self.qt = qt + 1
        updateQt(true)
    }

    /// Action remove  product.
    @objc private func removeProductAction() {
        guard let qt = qt else { return }
        self.qt = qt - 1
        updateQt(true)
    }
}

// MARK: - UITableViewDataSource

extension ProductInfoView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        controller?.getSections.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionComponent = controller?.getSections[section]

        switch sectionComponent {
        case .info(let components):
            return components.count
        case .otherProducts:
            // The section other products has its own data.
            return controller?.getOtherProducts.count ?? 0
        case .none:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        selectCell(indexPath)
    }
}

// MARK: - UITableViewDelegate

extension ProductInfoView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AppStyles.layer.cornerRadius * 3
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = controller?.getSections[indexPath.section]
        // Set the size of the screen elements based on the cell.
        switch section {
        case .info(let components) where components[indexPath.row] == .images:
            return tableView.frame.height * 0.6
        default:
            return UITableView.automaticDimension
        }
    }
}
