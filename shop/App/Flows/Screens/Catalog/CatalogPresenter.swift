//
//  CatalogPresenter.swift
//  shop
//
//  Created by Ke4a on 10.11.2022.
//

import UIKit

class CatalogPresenter {
    // MARK: - Public Properties

    /// Input view controller. For manages.
    weak var viewInput: (UIViewController & CatalogViewControllerInput)?

    // MARK: - Private Properties

    /// If any request ended with an error.
    private var requestisError = false
    /// Request response data
    private var response: ResponseCatalogModel?
    /// Shopping basket. Stored according to product ID.
    private var basket: [Int: Int]? = [:]

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
    private func checkCompleteRequests() {
        if (basket != nil && response != nil) || requestisError {
            viewInput?.loadingAnimation(false)
        }
    }
}

// MARK: - CatalogViewControllerOutput

extension CatalogPresenter: CatalogViewControllerOutput {
    func viewFetchBasket() {
        viewInput?.loadingAnimation(true)
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
    }

    var data: [ResponseProductModel] {
        response?.products ?? []
    }

    var currentPage: Int {
        response?.pageNumber ?? 1
    }

    var maxPage: Int {
        response?.maxPage ?? 1
    }

    func viewFetchData(page: Int, category: Int? = nil) {
        viewInput?.loadingAnimation(true)
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
            viewInput?.reloadCollectionView()
        case .failure:
            requestisError = true
        }

        checkCompleteRequests()
    }

    func interactorResponseCatalog(_ result: Result<ResponseCatalogModel, NetworkErrorModel>) {
        switch result {
        case .success(let success):
            self.response = success
            viewInput?.reloadCollectionView()
        case .failure:
            requestisError = true
        }

        checkCompleteRequests()
    }
}
