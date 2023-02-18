//
//  BasketInteractor.swift
//  shop
//
//  Created by Ke4a on 22.11.2022.
//

import Foundation

/// Interactor protocol for presenter "Basket". Contains business logic.
protocol BasketInteractorInput {
    /// Fetch basket products. Async.
    func requestBasket()
    /// Send the number of added units of product. Async.
    /// - Parameters:
    ///   - id: Product id.
    ///   - qt: Product quantity.
    func requestAddItemToBasket(_ id: Int, qt: Int)
    /// Send the number of remove units of product. Async.
    /// - Parameters:
    ///   - id: Product id.
    ///   - qt: Product quantity.
    ///   - deleteProduct: Delete product from view.
    func requestRemoveItemFromBasket(_ id: Int, qt: Int, deleteProduct: Bool)
    /// Request to remove all items from the cart. Async.
    func requestRemoveAllFromBasket()
}

/// Interactor protocol for presenter "Basket". Contains  interactor output logic.
protocol BasketInteractorOutput {
    /// Result of the basket request.
    /// - Parameter result: Result response succes/fail
    func interactorSendResponseBasket(_ result: [ResponseBasketModel])

    /// Result of the delete product from basket request.
    /// - Parameter id: Product id.
    func interactorDeleteProductBasketApi(_ id: Int)

    /// Result of the clear basket request.
    func interactorEmptyBasketApi()

    /// Interactor response if the request was completed with an error.
    /// - Parameter error: Error.
    func interactorSendResponseError(_ error: NetworkErrorModel)
}

/// Interactor. Contains business logic.
class BasketInteractor: BasketInteractorInput {
    // MARK: - Public Properties

    /// Controls the display of the view.
    weak var presenter: (AnyObject & BasketInteractorOutput)?

    // MARK: - Private Properties

    /// Network service.
    private let network: NetworkProtocol
    /// Decoder service.
    private let decoder: DecoderResponseProtocol

    // MARK: - Initialization

    /// Interactor for presenter "Basket". Contains business logic.
    /// - Parameters:
    ///   - network: Network service.
    ///   - decoder: Decoder srevice.
    init(network: NetworkProtocol, decoder: DecoderResponseProtocol) {
        self.network = network
        self.decoder = decoder
    }

    // MARK: - Public Methods

    func requestBasket() {
        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.basket) { [weak self] result in
                guard let self = self else { return }

                do {
                    switch result {
                    case .success(let data):
                        let response = try self.decoder.decode(data: data, model: [ResponseBasketModel].self)
                        self.presenter?.interactorSendResponseBasket(response)
                    case .failure(let error):
                        switch error {
                        case .clientError(_, let data):
                            let decodeError = try self.decoder.decodeError(data: data)
                            self.presenter?.interactorSendResponseError(decodeError)
                        default:
                            self.presenter?.interactorSendResponseError(
                                .init(error: true, reason: error.customMessage))
                        }
                    }
                } catch {
                    self.presenter?.interactorSendResponseError(
                        .init(error: true, reason: "App error"))
                }
            }
        }
    }

    func requestAddItemToBasket(_ id: Int, qt: Int) {
        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.addToBasket(id, qt)) { _ in }
        }
    }

    func requestRemoveItemFromBasket(_ id: Int, qt: Int, deleteProduct: Bool) {
        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.removeItemToBasket(id, qt)) { [weak self] result in
                guard let self = self else { return }

                if deleteProduct {
                    self.runFuncOnSuccessMessage(result) { [weak self] in
                        guard let self = self else { return }
                        self.presenter?.interactorDeleteProductBasketApi(id)
                    }
                } else {
    
                }
            }
        }
    }

    func requestRemoveAllFromBasket() {
        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.removeAllToBasket) { [weak self] result in
                guard let self = self, let closure = self.presenter?.interactorEmptyBasketApi else { return }
                self.runFuncOnSuccessMessage(result, closure)
            }
        }
    }

    // MARK: - Private Methods

    /// Run the function in case of a positive answer. If there is an error then it will call the error function.
    /// - Parameters:
    ///   - result: Request response.
    ///   - completion: The function to run.
    private func runFuncOnSuccessMessage(_ result: Result<Data, RequestError>, _ completion: () -> Void) {
        do {
            switch result {
            case .success:
                completion()
            case .failure(let error):
                switch error {
                case .clientError(_, let data):
                    let decodeError = try self.decoder.decodeError(data: data)
                    self.presenter?.interactorSendResponseError(decodeError)
                default:
                    self.presenter?.interactorSendResponseError(
                        .init(error: true, reason: error.customMessage))
                }
            }
        } catch {
            self.presenter?.interactorSendResponseError(
                .init(error: true, reason: "App error"))
        }
    }
}
