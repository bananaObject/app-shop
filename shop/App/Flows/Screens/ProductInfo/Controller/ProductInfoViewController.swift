//
//  ProductInfoViewController.swift
//  shop
//
//  Created by Ke4a on 13.11.2022.
//

import UIKit

/// Delegate controller input.
protocol ProductInfoViewControllerInput {
    /// Update the basic information on the view.
    func updateAllInfoOnScreen()

    /// Update the other products.
    func updateOtherProductsOnScreen()

    /// Enable/disable loading animation.
    /// - Parameter isEnable: Loading is enable.
    func loadingAnimation(_ isEnable: Bool)
}

/// Delegate controller output.
protocol ProductInfoViewControllerOutput {
    /// Product info.
    var getDataInfo: ResponseProductModel? { get }
    /// Section screen. The table is built on this data.
    var getSections: [AppDataScreen.productInfo.Сomponent] { get }
    /// Other product.
    var getOtherProducts: [[ResponseProductModel]] { get }
    /// Product quantity.
    var qtProduct: Int { get set }

    /// View requested basic information about the product.
    func viewRequestsInfo()

    /// View requested open product.
    /// - Parameter id: Product id.
    func viewOpenProduct(_ id: Int)
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
    private var presenter: ProductInfoViewControllerOutput?

    // MARK: - Initialization

    /// Presenter with screen control.
    /// - Parameter presenter: Presenter with screen control protocol
    init(presenter: ProductInfoViewControllerOutput) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
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
        presenter?.viewRequestsInfo()
    }
}

// MARK: - ProductInfoViewControllerInput

extension ProductInfoViewController: ProductInfoViewControllerInput {
    func loadingAnimation(_ isEnable: Bool) {
        DispatchQueue.main.async {
            self.infoView.loadingAnimation(isEnable)
        }
    }

    func updateOtherProductsOnScreen() {
        DispatchQueue.main.async {
            self.infoView.updateOtherProductsOnScreen()
        }
    }

    func updateAllInfoOnScreen() {
        DispatchQueue.main.async {
            self.infoView.updateAllInfoOnScreen()
        }
    }
}

// MARK: - ProductInfoViewOutput

extension ProductInfoViewController: ProductInfoViewOutput {
    var qtProduct: Int {
        get {
            presenter?.qtProduct ?? 0
        }
        set {
            presenter?.qtProduct = newValue
        }
    }

    var getSections: [AppDataScreen.productInfo.Сomponent] {
        presenter?.getSections ?? []
    }

    var getOtherProducts: [[ResponseProductModel]] {
        presenter?.getOtherProducts ?? []
    }

    var getDataInfo: ResponseProductModel? {
        presenter?.getDataInfo
    }

    func viewSendId(_ id: Int) {
        presenter?.viewOpenProduct(id)
    }
}
