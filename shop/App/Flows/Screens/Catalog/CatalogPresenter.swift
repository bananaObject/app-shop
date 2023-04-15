//
//  CatalogPresenter.swift
//  shop
//
//  Created by Ke4a on 10.11.2022.
//

import UIKit

struct CatalogCellModel {
    let id: Int
    let name: String
    let price: Int
    let imageUrl: String?
    var imageData: Data?
}

class CatalogPresenter: Analyticable {
    // MARK: - Public Properties
    private(set) var isLoading: Bool = false
    private(set) var currentPage: Int = 1
    private(set) var maxPage: Int = 1
    private(set) var data: [CatalogCellModel] = []
    /// Input view controller. For manages.
    weak var viewInput: (UIViewController & CatalogViewControllerInput)?

    // MARK: - Private Properties

    private var loadingAnimation: Bool = false
    /// If any request ended with an error.
    private var requestisError = false
    /// Shopping basket. Stored according to product ID.
    private var basket: [Int: Int]?

    /// Catalog category
    private var category: Int?

    /// Interactor. Contains business logic.
    private let interactor: CatalogInteractorInput
    /// Router. Navigating between screens..
    private let router: CatalogRouterInput

    // MARK: - Initialization

    /// Init  "Catalog" presenter. Manages user interaction and view.
    /// - Parameters:
    ///   - interactor: Contains business logic.
    ///   - router: Navigating between screens.
    init(interactor: CatalogInteractorInput, router: CatalogRouterInput) {
        self.interactor = interactor
        self.router = router
    }

    // MARK: - Private Properties

    /// Checks all requests are completed.
    private func checkCompleteRequests(indexes: [IndexPath]? = nil) {
        guard (basket != nil && !data.isEmpty) || requestisError else {
            return
        }

        if !requestisError {
            viewInput?.updateButtonBasket()
            if let indexes {
                viewInput?.insertItems(indexPaths: indexes)
            } else {
                viewInput?.reloadCollectionView()
            }
        }
        if loadingAnimation {
            viewInput?.loadingAnimation(false)
        }
    }
}

// MARK: - CatalogViewControllerOutput

extension CatalogPresenter: CatalogViewControllerOutput {
    func viewFetchImage(indexPath: IndexPath) {
        guard let url = data[indexPath.item].imageUrl else { return }

        interactor.fetchImageAsync(url: url) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let imageData):
                self.data[indexPath.item].imageData = imageData
                self.viewInput?.reloadItems(indexPaths: [indexPath])
            case .failure:
                break
            }
        }
    }

    func viewSendAnalytic() {
        sendAnalytic(.watchingCatalogScreen(currentPage, category))
    }

    func viewOpenBasket() {
        router.openBasket()
    }

    func viewOpenProductInfo(_ index: Int) {
        let id = data[index].id
        router.openProductInfo(id)
    }

    func viewFetchBasket() {
        interactor.fetchBasketAsync()
    }

    func viewAddProductToCart(_ index: Int, qt: Int) {
        let id = data[index].id

        if let productQt = basket?[id] {
            basket?.updateValue(productQt + qt, forKey: id)
        } else {
            basket?[id] = qt
        }

        interactor.fetchAddItemToBasketAsync(id, qt: qt)
        sendAnalytic(.addedProductToBasket(id, qt: qt))
    }

    var basketIsEmpty: Bool {
        basket?.isEmpty ?? true
    }

    func viewFetchData(page: Int, category: Int? = nil, loading animation: Bool) {
        self.loadingAnimation = animation
        isLoading = true
        if loadingAnimation {
            viewInput?.loadingAnimation(true)
        }
        interactor.fetchCatalogAsync(page: page, category: category)
    }

    func getQtToBasket(_ index: Int) -> Int {
        let id = data[index].id

        return basket?[id] ?? 0
    }
}

// MARK: - CatalogInteractorOutput

extension CatalogPresenter: CatalogInteractorOutput {
    func interactorResponseBasket(_ result: Result<[Int: Int], NetworkErrorModel>) {
        switch result {
        case .success(let success):
            basket = success
        case .failure:
            requestisError = true
        }

        checkCompleteRequests()
    }

    func interactorResponseCatalog(_ result: Result<ResponseCatalogModel, NetworkErrorModel>) {
        isLoading = false

        var newIndexes: [IndexPath]?

        switch result {
        case .success(let success):
            let endIndex = data.endIndex
            newIndexes = success.products.indices.map { .init(item: $0 + endIndex, section: 0) }
            currentPage = success.pageNumber
            maxPage = success.maxPage
            data += success.products.map { CatalogCellModel(id: $0.id,
                                                            name: $0.name,
                                                            price: $0.price,
                                                            imageUrl: $0.imageSmall,
                                                            imageData: nil)
            }
        case .failure:
            requestisError = true
        }

        checkCompleteRequests(indexes: newIndexes)
    }
}
