//
//  BasketService.swift
//  shop
//
//  Created by Ke4a on 15.09.2022.
//

import Foundation

final class BasketService {
    // MARK: - Public Properties

    var data: [ResponseBasketModel]?

    // MARK: - Private Properties

    private let product: ResponseProductModel
    private let creditCard: String

    private let network: NetworkProtocol
    private let decoder: DecoderResponseProtocol

    // MARK: - Initialization
    
    init(_ network: NetworkProtocol, _ decoder: DecoderResponseProtocol) {
        self.network = network
        self.decoder = decoder

        self.product = ResponseProductModel(id: 1,
                                            category: 1,
                                            name: "Товар 1",
                                            price: 60217,
                                            description: "Мощный товар 1")
        self.creditCard = "9872389-2424-234224-234"
    }

    // MARK: - Public Methods

    /// Remove item to basket.
    func fetchRemoveItemToBasketAsync() {
        let id = self.product.id

        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.removeItemToBasket(id)) {
                // Отключил пока вызывается в appDelegate, так как там не сохраняется
                // [weak self]
                result in

                // guard let self = self else { return }

                do {
                    switch result {
                    case .success:
                        guard let index = self.data?.firstIndex(where: { $0.product.id == self.product.id }),
                              let quantity = self.data?[index].quantity else { return }

                        if quantity <= 1 {
                            self.data?.remove(at: index)
                        } else {
                            self.data?[index].quantity -= 1
                        }
                    case .failure(let error):
                        switch error {
                        case .clientError(let status, let data):
                            let decodeError = try self.decoder.decodeError(data: data)
                            print("status: \(status) \n\(decodeError)")
                        default:
                            throw error
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
    }

    /// Clear basket.
    func fetchRemoveAllToBasketAsync() {
        let id = self.product.id

        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.removeAllToBasket) {
                // Отключил пока вызывается в appDelegate, так как там не сохраняется
                // [weak self]
                result in

                // guard let self = self else { return }

                do {
                    switch result {
                    case .success:
                        self.data?.removeAll()
                    case .failure(let error):
                        switch error {
                        case .clientError(let status, let data):
                            let decodeError = try self.decoder.decodeError(data: data)
                            print("status: \(status) \n\(decodeError)")
                        default:
                            throw error
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
    }

    /// Fetch pay basket.
    func fetchPayBasketAsync() {
        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.payBasket(self.creditCard)) {
                // Отключил пока вызывается в appDelegate, так как там не сохраняется
                // [weak self]
                result in

                // guard let self = self else { return }

                do {
                    switch result {
                    case .success:
                        self.data?.removeAll()
                    case .failure(let error):
                        switch error {
                        case .clientError(let status, let data):
                            let decodeError = try self.decoder.decodeError(data: data)
                            print("status: \(status) \n\(decodeError)")
                        default:
                            throw error
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}
