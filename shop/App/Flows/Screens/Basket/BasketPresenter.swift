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
    private var dataBasket: [ResponseBasketModel] = []

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
    func viewRequestPayment() {
        router.openPaymentFormSheet(self)
    }

    var totalCost: Int {
        dataBasket.reduce(0) { $0 + $1.product.price * $1.quantity }
    }

    func viewSendNewQtProduct(id: Int, qt: Int) {
        guard let index = dataBasket.firstIndex(where: { $0.product.id == id }) else { return }
        let oldQt = dataBasket[index].quantity

        guard  qt != oldQt else { return }
        let difference = qt - oldQt
        dataBasket[index].quantity += difference

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
        DispatchQueue.main.async {
            self.interactor.requestBasket()
            self.viewInput?.loadingAnimation(loadingAnimation)
        }
    }

    var data: [ResponseBasketModel] {
        self.dataBasket
    }
}

// MARK: - BasketInteractorOutput

extension BasketPresenter: BasketInteractorOutput {
    func interactorDeleteProductBasketApi(_ id: Int) {
        guard let index = dataBasket.firstIndex(where: { $0.product.id == id }) else { return }
        dataBasket.remove(at: index)
        DispatchQueue.main.async {
            self.viewInput?.deleteRowTableView(IndexPath(row: index, section: 0))
            self.viewInput?.setTrashButton(self.dataBasket.isEmpty)
        }
    }

    func interactorEmptyBasketApi() {
        dataBasket.removeAll()
        DispatchQueue.main.async {
            self.viewInput?.reloadTableView()
            self.viewInput?.setTrashButton(self.dataBasket.isEmpty)
        }
    }

    func interactorSendResponseBasket(_ result: [ResponseBasketModel]) {
        dataBasket = result
        DispatchQueue.main.async {
            self.viewInput?.reloadTableView()
            self.viewInput?.setTrashButton(self.dataBasket.isEmpty)
            self.viewInput?.loadingAnimation(false)
        }
    }

    func interactorSendResponseError(_ error: NetworkErrorModel) {
        print(error)
        self.viewInput?.loadingAnimation(false)
    }
}
