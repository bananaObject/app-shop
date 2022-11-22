//
//  ProductInfoPresenter.swift
//  shop
//
//  Created by Ke4a on 13.11.2022.
//

import UIKit

class ProductInfoPresenter {
    // MARK: - Public Properties

    /// Input view controller. For manages.
    weak var viewInput: (AnyObject & ProductInfoViewControllerInput)?

    // MARK: - Private Properties

    /// Screen sections.
    private var dataSections: [AppDataScreen.productInfo.Сomponent] = []
    /// Product info.
    private var dataInfo: ResponseProductModel?
    /// Other products.
    private var dataOtherProducts: [[ResponseProductModel]]?

    /// Product id.
    private let id: Int
    /// Interactor. Contains business logic.
    private let interactor: ProductInfoInteractorInput
    /// Router. Navigating between screens..
    private let router: ProductInfoRouterInput

    // MARK: - Initialization

    /// Init  "Product info" presenter. Manages user interaction and view.
    /// - Parameters:
    ///   - interactor: Contains business logic.
    ///   - router: Navigating between screens.
    ///   - id: Product id.
    init(interactor: ProductInfoInteractorInput, router: ProductInfoRouterInput, product id: Int) {
        self.interactor = interactor
        self.router = router
        self.id = id
    }
}

// MARK: - ProductInfoInteractorOutput

extension ProductInfoPresenter: ProductInfoInteractorOutput {
    func interactorResponseInfo(_ response: ResponseProductModel) {
        dataInfo = response
        viewInput?.updateAllInfoOnScreen()
        // The request for other products is made after the master data is loaded.
        interactor.fetchOtherProductsAsync(self.id, response.category)
        viewInput?.loadingAnimation(false)
    }

    func interactorResponseOtherProducts(_ response: [[ResponseProductModel]]) {
        dataOtherProducts = response
        viewInput?.updateOtherProductsOnScreen()
    }

    func interactorResponseError(_ error: NetworkErrorModel) {
        viewInput?.loadingAnimation(false)
        print(error)
    }
}

// MARK: - ProductInfoInteractorOutput

extension ProductInfoPresenter: ProductInfoViewControllerOutput {
    var qtProduct: Int {
        get {
            self.dataInfo?.qt ?? 0
        }
        set {
            let qt: Int = self.dataInfo?.qt ?? 0

            guard newValue != qt else { return }

            let tempQt = newValue - qt

            // If the goods the number of goods has decreased, then delete the goods.
            if tempQt > 0 {
                interactor.fetchAddItemToBasketAsync(self.id, qt: tempQt)
            } else if tempQt < 0 {
                interactor.fetchRemoveItemToBasketAsync(self.id, qt: -tempQt)
            }

            self.dataInfo?.qt = newValue
        }
    }

    var getSections: [AppDataScreen.productInfo.Сomponent] {
        // If the main data has not yet been loaded, then we return an empty array so that the page is not collected.
        dataInfo != nil ? AppDataScreen.productInfo.sectionTableView : []
    }

    var getOtherProducts: [[ResponseProductModel] ] {
        self.dataOtherProducts ?? []
    }

    var getDataInfo: ResponseProductModel? {
        self.dataInfo
    }

    func viewOpenProduct(_ id: Int) {
        router.openProductInfo(id)
    }
    
    func viewRequestsInfo() {
        viewInput?.loadingAnimation(true)
        interactor.fetchInfoAsync(self.id)
    }
}
