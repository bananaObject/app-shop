//
//  ProductInfoPresenter.swift
//  shop
//
//  Created by Ke4a on 13.11.2022.
//

import UIKit

class ProductInfoPresenter: Analyticable {
    // MARK: - Public Properties

    /// Input view controller. For manages.
    weak var viewInput: (AnyObject & ProductInfoViewControllerInput)?

    // MARK: - Private Properties

    /// Screen sections.
    private var dataSections: [AppDataScreen.productInfo.Сomponent] = []
    /// Product info.
    private var dataInfo: ProductInfoViewModel?
    /// Other products.
    private var dataOtherProducts: [[OtherProductInfoViewModel]]?

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

    /// Loading product images.
    /// - Parameter urls: Images urls.
    private func loadImagesProduct(images urls: [String]) {
        let group = DispatchGroup()
        var dataImages: [Data] = []

        urls.forEach { url in
            group.enter()
            self.interactor.fetchImageAsync(url: url) { result in
                switch result {
                case .success(let data):
                    dataImages.append(data)
                case .failure(let failure):
                    print(failure)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.dataInfo?.images = dataImages
            self.viewInput?.update(component: .image)
        }
    }

    /// Loading images for cell  other products cell.
    /// - Parameter index: Cell index.
    private func loadImagesOtherProducts(index: IndexPath) {
        let group = DispatchGroup()
        self.dataOtherProducts?[index.row].enumerated().forEach({ indexItem, item in
            if let url = item.image {
                group.enter()
                self.interactor.fetchImageAsync(url: url) { [weak self] result in
                    switch result {
                    case .success(let data):
                        self?.dataOtherProducts?[index.row][indexItem].imageData = data
                    case .failure(let failure):
                        print(failure)
                    }
                    group.leave()
                }
            }

        })
        group.notify(queue: .main) {
            self.viewInput?.update(component: .cell(index))
        }
    }
}

// MARK: - ProductInfoInteractorOutput

extension ProductInfoPresenter: ProductInfoInteractorOutput {
    func interactorResponseInfo(_ response: ResponseProductModel) {
        if dataInfo == nil {
            dataInfo = ProductInfoViewModel(id: response.id, name: response.name, price: response.price,
                                            description: response.description ?? "Error description",
                                            qt: response.qt ?? 0,
                                            lastReview: response.lastReview)
            if let images = response.images {
                DispatchQueue.global().async {
                    self.loadImagesProduct(images: images)
                }
            }
            viewInput?.update(component: .all)
            interactor.fetchOtherProductsAsync(self.id, response.category)
        } else {
            if let newQt = response.qt, dataInfo?.qt != newQt {
                dataInfo?.qt = newQt
                viewInput?.update(component: .qt(newQt))
            }
        }
        viewInput?.loadingAnimation(false)
    }

    func interactorResponseOtherProducts(_ response: [ResponseProductModel]) {
        dataOtherProducts = interactor.convertOtherProductIntoCell(response: response, qtInCell: 3)
        viewInput?.update(component: .otherProduct)
    }

    func interactorResponseError(_ error: NetworkErrorModel) {
        viewInput?.loadingAnimation(false)
        print(error)
    }
}

// MARK: - ProductInfoInteractorOutput

extension ProductInfoPresenter: ProductInfoViewControllerOutput {
    func viewRequestsOtherProductImage(index: IndexPath) {
        DispatchQueue.main.async {
            self.loadImagesOtherProducts(index: index)
        }
    }

    func viewSendError(_ error: ErrorForAnalytic) {
        sendAnalytic(.applicationError(error))
    }

    func viewSendAnalytic() {
        sendAnalytic(.watchingProductScreen(id))
    }

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
                sendAnalytic(.addedProductToBasket(id, qt: tempQt))
            } else if tempQt < 0 {
                interactor.fetchRemoveItemToBasketAsync(self.id, qt: -tempQt)
                sendAnalytic(.removedProductFromBasket(id, qt: -tempQt))
            }

            self.dataInfo?.qt = newValue
        }
    }

    var getSections: [AppDataScreen.productInfo.Сomponent] {
        // If the main data has not yet been loaded, then we return an empty array so that the page is not collected.
        dataInfo != nil ? AppDataScreen.productInfo.sectionTableView : []
    }

    var getOtherProducts: [[OtherProductInfoViewModel] ] {
        self.dataOtherProducts ?? []
    }

    var getDataInfo: ProductInfoViewModel? {
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
