//
//  ProductInfoViewController.swift
//  shop
//
//  Created by Ke4a on 13.11.2022.
//

import UIKit

/// Delegate controller input.
protocol ProductInfoViewControllerInput {
    /// Update component on view..
    func update(component: Update)

    /// Enable/disable loading animation.
    /// - Parameter isEnable: Loading is enable.
    func loadingAnimation(_ isEnable: Bool)
}

/// Delegate controller output.
protocol ProductInfoViewControllerOutput {
    /// Product info.
    var getDataInfo: ProductInfoViewModel? { get }
    /// Section screen. The table is built on this data.
    var getSections: [AppDataScreen.productInfo.Сomponent] { get }
    /// Other products.
    var getOtherProducts: [[OtherProductInfoViewModel]] { get }
    /// Product quantity.
    var qtProduct: Int { get set }

    /// View requested basic information about the product.
    func viewRequestsInfo()

    /// View requests images of other products by index.
    /// - Parameter index: Index cell.
    func viewRequestsOtherProductImage(index: IndexPath)

    /// View requested open product.
    /// - Parameter id: Product id.
    func viewOpenProduct(_ id: Int)

    /// View send analytic;
    func viewSendAnalytic()

    /// View send error;
    /// - Parameter error: Error.
    func viewSendError(_ error: ErrorForAnalytic)
}

class ProductInfoViewController: UIViewController {
    // MARK: - Visual Components

    /// Screen view.
    private var infoView: ProductInfoView {
        guard let view = self.view as? ProductInfoView else {
            let vc = ProductInfoView(self)
            self.view = vc
            return vc
        }

        return view
    }

    /// Presenter with screen control.
    private var presenter: ProductInfoViewControllerOutput

    // MARK: - Initialization

    /// Presenter with screen control.
    /// - Parameter presenter: Presenter with screen control protocol
    init(presenter: ProductInfoViewControllerOutput) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        self.view = ProductInfoView(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        infoView.setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewRequestsInfo()
        presenter.viewSendAnalytic()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        infoView.flashScrollIndicator()
    }
}

// MARK: - ProductInfoViewControllerInput

extension ProductInfoViewController: ProductInfoViewControllerInput {
    func update(component: Update) {
        DispatchQueue.main.async {
            self.infoView.update(component: component)
        }
    }

    func loadingAnimation(_ isEnable: Bool) {
        DispatchQueue.main.async {
            self.infoView.loadingAnimation(isEnable)
        }
    }
}

// MARK: - ProductInfoViewOutput

extension ProductInfoViewController: ProductInfoViewOutput {
    func viewRequestsOtherProductImage(index: IndexPath) {
        presenter.viewRequestsOtherProductImage(index: index)
    }

    func viewSendError(_ error: ErrorForAnalytic) {
        presenter.viewSendError(error)
    }

    var qtProduct: Int {
        get {
            presenter.qtProduct
        }
        set {
            presenter.qtProduct = newValue
        }
    }

    var getSections: [AppDataScreen.productInfo.Сomponent] {
        presenter.getSections
    }

    var getOtherProducts: [[OtherProductInfoViewModel]] {
        presenter.getOtherProducts
    }

    var getDataInfo: ProductInfoViewModel? {
        presenter.getDataInfo
    }

    func viewSendId(_ id: Int) {
        presenter.viewOpenProduct(id)
    }
}
