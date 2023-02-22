//
//  CatalogInteractor.swift
//  shop
//
//  Created by Ke4a on 10.11.2022.
//

import UIKit

/// Interactor protocol for presenter "Catalog". Contains business logic.
protocol CatalogInteractorInput {
    /// Fetch async data.
    /// The decoded models are written to the date property.
    /// - Parameters:
    ///   - page: Pagination page.
    ///   - category: Category number
    func fetchCatalogAsync(page: Int, category: Int?)

    /// Fetch add product in basket.
    /// - Parameters:
    ///   - id: Product id.
    ///   - qt: Quantity.
    func fetchAddItemToBasketAsync(_ id: Int, qt: Int)

    /// Fetch basket products.
    func fetchBasketAsync()

    /// Downloading image data from internet.
    /// - Parameters:
    ///   - url: Image URL
    ///   - completion: Will send image data or an error.
    func fetchImageAsync(url: String, completion: @escaping (Result<Data, ImageLoaderError>) -> Void)
}

/// Interactor protocol for presenter "Catalog". Contains  interactor output logic.
protocol CatalogInteractorOutput {
    /// Result of the directory request.
    /// - Parameter result: Result response succes/fail
    func interactorResponseCatalog(_ result: Result<ResponseCatalogModel, NetworkErrorModel>)

    /// Result of the basket request.
    /// - Parameter result: Result response succes/fail
    func interactorResponseBasket(_ result: Result<[Int: Int], NetworkErrorModel>)
}

class CatalogInteractor: CatalogInteractorInput {
    // MARK: - Public Properties

    /// Controls the display of the view.
    weak var presenter: (AnyObject & CatalogInteractorOutput)?

    // MARK: - Private Properties

    /// Network layer.
    private let network: NetworkProtocol
    /// Response decoder.
    private let decoder: DecoderResponseProtocol

    private let imageLoader: ImageLoaderProtocol

    // MARK: - Initialization

    /// Interactor for presenter "Catalog". Contains business logic.
    /// - Parameters:
    ///   - network: Network service.
    ///   - decoder: Decoder srevice.
    ///   - loaderImage:  Image loader.
    init(network: Network, decoder: DecoderResponse, imageLoader: ImageLoaderProtocol) {
        self.network = network
        self.decoder = decoder
        self.imageLoader = imageLoader
    }

    // MARK: - Public Methods

    func fetchCatalogAsync(page: Int = 1, category: Int? = nil) {
        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.catalog(page, category)) {  [weak self] result in
                guard let self = self else { return }

                do {
                    switch result {
                    case .success(let data):
                        // Decode response
                        let response = try self.decoder.decode(data: data, model: ResponseCatalogModel.self)
                        self.presenter?.interactorResponseCatalog(.success(response))
                    case .failure(let error):
                        switch error {
                        case .clientError(_, let data):
                            let decodeError = try self.decoder.decodeError(data: data)
                            self.presenter?.interactorResponseCatalog(.failure(decodeError))
                        default:
                            self.presenter?.interactorResponseCatalog(.failure(
                                .init(error: true, reason: error.customMessage)
                            ))
                        }
                    }
                } catch {
                    self.presenter?.interactorResponseCatalog(.failure(
                        .init(error: true, reason: "App error")
                    ))
                }
            }
        }
    }

    func fetchAddItemToBasketAsync(_ id: Int, qt: Int) {
        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.addToBasket(id, qt)) { _ in }
        }
    }

    func fetchImageAsync(url: String, completion: @escaping (Result<Data, ImageLoaderError>) -> Void) {
        self.imageLoader.fetchAsync(url: url, completion: completion)
    }

    func fetchBasketAsync() {
        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.basket) { [weak self] result in
                guard let self = self else { return }

                do {
                    switch result {
                    case .success(let data):
                        let response = try self.decoder.decode(data: data, model: [ResponseBasketModel].self)
                        let convertResponse = self.convertForQuantity(response)
                        self.presenter?.interactorResponseBasket(.success(convertResponse))
                    case .failure(let error):
                        switch error {
                        case .clientError(_, let data):
                            let decodeError = try self.decoder.decodeError(data: data)
                            self.presenter?.interactorResponseBasket(.failure(decodeError))
                        default:
                            self.presenter?.interactorResponseBasket(.failure(
                                .init(error: true, reason: error.customMessage)
                            ))
                        }
                    }
                } catch {
                    self.presenter?.interactorResponseBasket(.failure(
                        .init(error: true, reason: "App error")
                    ))
                }
            }
        }
    }

    // MARK: - Private Methods
    
    /// Convert to Dictionary id:count.
    /// - Parameter basket: Respons basket,
    /// - Returns: Dictionary id:count
    private func convertForQuantity(_ basket: [ResponseBasketModel]) -> [Int: Int] {
        basket.reduce([Int: Int]()) { partialResult, item in
            let id = item.product.id
            var newValue = partialResult
            guard let qt = partialResult[id] else {
                newValue[id] = item.quantity
                return newValue
            }
            newValue[id] = qt + item.quantity
            return newValue
        }
    }
}
