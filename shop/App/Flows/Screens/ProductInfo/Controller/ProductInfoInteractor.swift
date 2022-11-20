//
//  ProductInfoInteractor.swift
//  shop
//
//  Created by Ke4a on 13.11.2022.
//

import Foundation

/// Interactor protocol for presenter "Product info". Contains business logic.
protocol ProductInfoInteractorInput {
    /// Product information request.
    /// - Parameter id: Product id.
    func fetchInfoAsync(_ id: Int)
    /// Request a catalog of other products of the same category.
    /// - Parameter category: Product category.
    /// - Parameter id: Product id. Which should not be in the answer.
    func fetchOtherProductsAsync(_ id: Int, _ category: Int)
    /// Send the number of added units of product.
    /// - Parameters:
    ///   - id: Product id.
    ///   - qt: Product quantity.
    func fetchAddItemToBasketAsync(_ id: Int, qt: Int)
    /// Send the number of remove units of product.
    /// - Parameters:
    ///   - id: Product id.
    ///   - qt: Product quantity.
    func fetchRemoveItemToBasketAsync(_ id: Int, qt: Int)
}

/// Interactor protocol for presenter "Product info" Contains  interactor output logic.
protocol ProductInfoInteractorOutput {
    /// Response of the interactor with the result of the request for information.
    /// - Parameter response: Product info.
    func interactorResponseInfo(_ response: ResponseProductModel)
    /// Interactor response with the result of a request for a catalog of other products.
    /// - Parameter response: Other products catalog.
    func interactorResponseOtherProducts(_ response: [[ResponseProductModel]])
    /// Interactor response if the request was completed with an error.
    /// - Parameter error: Error.
    func interactorResponseError(_ error: NetworkErrorModel)
}

class ProductInfoInteractor: ProductInfoInteractorInput {
    // MARK: - Public Properties

    /// Controls the display of the view.
    weak var presenter: (AnyObject & ProductInfoInteractorOutput)?

    // MARK: - Private Properties

    /// Network layer.
    private let network: NetworkProtocol
    /// Response decoder.
    private let decoder: DecoderResponseProtocol

    // MARK: - Initialization

    /// Interactor for presenter "Product Info". Contains business logic.
    /// - Parameters:
    ///   - network: Network service.
    ///   - decoder: Decoder srevice.
    init(network: Network, decoder: DecoderResponse) {
        self.network = network
        self.decoder = decoder
    }

    // MARK: - Public Methods

    func fetchInfoAsync(_ id: Int) {
        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.product(id)) {  [weak self] result in
                guard let self = self else { return }

                do {
                    switch result {
                    case .success(let data):
                        // Decode response
                        let response = try self.decoder.decode(data: data, model: ResponseProductModel.self)
                        self.presenter?.interactorResponseInfo(response)
                    case .failure(let error):
                        switch error {
                        case .clientError(_, let data):
                            let decodeError = try self.decoder.decodeError(data: data)
                            self.presenter?.interactorResponseError(decodeError)
                        default:
                            self.presenter?.interactorResponseError(.init(error: true, reason: error.customMessage))
                        }
                    }
                } catch {
                    self.presenter?.interactorResponseError(.init(error: true, reason: "App error"))
                }
            }
        }
    }

    func fetchOtherProductsAsync(_ id: Int, _ category: Int) {
        DispatchQueue.global(qos: .background).async {
            // By default, the first page, it contains products that need to be sold first.
            self.network.fetch(.catalog(1, category)) {  [weak self] result in
                guard let self = self else { return }

                do {
                    switch result {
                    case .success(let data):
                        // Decode response and remove from the array by id.
                        let response = try self.decoder.decode(data: data, model: ResponseCatalogModel.self)
                            .products
                            .filter { $0.id != id }

                        // Here is an answer convenient for building a screen.
                        let convertResponse = self.convertOtherProductIntoCell(
                            response: response,
                            qtInCell: AppDataScreen.productInfo.qtInCellOtherProducts
                        )
                        self.presenter?.interactorResponseOtherProducts(convertResponse)
                    case .failure(let error):
                        switch error {
                        case .clientError(_, let data):
                            let decodeError = try self.decoder.decodeError(data: data)
                            self.presenter?.interactorResponseError(decodeError)
                        default:
                            self.presenter?.interactorResponseError(.init(error: true, reason: error.customMessage))
                        }
                    }
                } catch {
                    self.presenter?.interactorResponseError(.init(error: true, reason: "App error"))
                }
            }
        }
    }

    func fetchAddItemToBasketAsync(_ id: Int, qt: Int) {
        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.addToBasket(id, qt)) { _ in }
        }
    }

    func fetchRemoveItemToBasketAsync(_ id: Int, qt: Int) {
        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.removeItemToBasket(id, qt)) { _ in }
        }
    }

    // MARK: - Private Methods
    /// Distribute into cells.
    /// - Parameters:
    ///   - response: Other products response.
    ///   - qtInCell: Number of elements in a cell.
    /// - Returns: Array for cells.
    private func convertOtherProductIntoCell(response: [ResponseProductModel],
                                             qtInCell: Int) -> [[ResponseProductModel]] {
        var response = response
        // Making an array for cells
        return response.reduce([[ResponseProductModel]]()) { partialResult, _ in
            guard !response.isEmpty else { return partialResult }

            var array: [ResponseProductModel] = []

            for _ in 0..<qtInCell {
                if !response.isEmpty {
                    array.append(response.removeFirst())
                }
            }
            
            return partialResult + [array]
        }
    }
}
