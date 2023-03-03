//
//  BasketPresenter.swift
//  shop
//
//  Created by Ke4a on 22.11.2022.
//

import Foundation

/// "Basket" presenter. Manages user interaction and view.
class BasketPresenter: Analyticable {
    // MARK: - Public Properties

    /// Input view controller. For manages.
    weak var viewInput: (AnyObject & BasketViewControllerInput)?
    
    // MARK: - Private Properties

    /// Basket data.
    private(set) var data: [BasketViewCellModel] = []

    /// Interactor. Contains business logic.
    private let interactor: BasketInteractorInput
    /// Router. Navigating between screens..
    private let router: BasketRouterInput

    // MARK: - Initialization

    /// "Basket" presenter. Manages user interaction and view.
    /// - Parameters:
    ///   - interactor: Contains business logic.
    ///   - router: Navigating between screens.
    init(interactor: BasketInteractorInput, router: BasketRouterInput) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - PaymentMockViewControllerDelegate

extension BasketPresenter: PaymentMockViewControllerDelegate {
    func paymentIsSucces(_ isSucces: Bool) {
        DispatchQueue.main.async {
            self.sendAnalytic(.payment(isSucces))
            if isSucces {
                self.viewInput?.showPaymentAlert("Payment successful!")
                self.interactor.requestRemoveAllFromBasket()
            } else {
                self.viewInput?.showPaymentAlert("Payment failed!")
            }
            self.viewInput?.stopLoadingIndicatorButton()
        }

    }
}

// MARK: - BasketViewControllerOutput

extension BasketPresenter: BasketViewControllerOutput {
    func viewFetchImage(indexPath: IndexPath) {
        guard let url = data[indexPath.row].imageUrl else { return }

        interactor.fetchImageAsync(url: url) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let imageData):
                self.data[indexPath.row].imageData = imageData
                // Reload the table completely, as there is a bug with a single cell reload
                self.viewInput?.reloadTableView()
            case .failure:
                break
            }
        }
    }

    func viewRequestPayment() {
        router.openPaymentFormSheet(self)
    }

    var totalCost: Int {
        data.reduce(0) { $0 + $1.price * $1.quantity }
    }

    func viewSendNewQtProduct(id: Int, qt: Int) {
        guard let index = data.firstIndex(where: { $0.id == id }) else { return }
        let oldQt = data[index].quantity

        guard  qt != oldQt else { return }
        let difference = qt - oldQt
        data[index].quantity += difference

        viewInput?.updateTotalCost()

        if difference > 0 {
            interactor.requestAddItemToBasket(id, qt: difference)
            sendAnalytic(.addedProductToBasket(id, qt: difference))
        } else if difference < 0 {
            interactor.requestRemoveItemFromBasket(id, qt: -difference, deleteProduct: oldQt == -difference)
            sendAnalytic(.removedProductFromBasket(id, qt: -difference))
        }
    }

    func viewRequestedToEmptyBasket() {
        interactor.requestRemoveAllFromBasket()
    }

    func viewRequestedBasket(_ loadingAnimation: Bool) {
        self.interactor.requestBasket()
        self.viewInput?.loadingAnimation(loadingAnimation)
    }
}

// MARK: - BasketInteractorOutput

extension BasketPresenter: BasketInteractorOutput {
    func interactorDeleteProductBasketApi(_ id: Int) {
        guard let index = data.firstIndex(where: { $0.id == id }) else { return }
        data.remove(at: index)
        DispatchQueue.main.async {
            self.viewInput?.deleteRowTableView(IndexPath(row: index, section: 0))
            self.viewInput?.setTrashButton(self.data.isEmpty)
        }
    }

    func interactorEmptyBasketApi() {
        data.removeAll()
        DispatchQueue.main.async {
            self.viewInput?.deleteAllRows()
            self.viewInput?.setTrashButton(self.data.isEmpty)
        }
    }

    func interactorSendResponseBasket(_ result: [ResponseBasketModel]) {
        data = result
            .sorted(by: { $0.product.id < $1.product.id })
            .map({ BasketViewCellModel(id: $0.product.id, name: $0.product.name,
                                       price: $0.product.price, quantity: $0.quantity,
                                       imageUrl: $0.product.imageSmall)})
        DispatchQueue.main.async {
            self.viewInput?.reloadTableView()
            self.viewInput?.setTrashButton(self.data.isEmpty)
            self.viewInput?.loadingAnimation(false)
        }
    }

    func interactorSendResponseError(_ error: NetworkErrorModel) {
        DispatchQueue.main.async {
            print(error)
            self.viewInput?.loadingAnimation(false)
        }
    }
}
