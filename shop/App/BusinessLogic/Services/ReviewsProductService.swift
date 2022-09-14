//
//  ReviewsProductService.swift
//  shop
//
//  Created by Ke4a on 13.09.2022.
//

import Foundation

/// Reviews product service.
class ReviewsProductService {
    typealias Model = ResponseReviewsProductModel

    // MARK: - Private Properties
    private let page: Int
    private let productId: Int

    private(set) var data: Model?

    private let network: NetworkProtocol
    private let decoder: DecoderResponseProtocol

    // MARK: - Initialization

    init(_ network: NetworkProtocol, _ decoder: DecoderResponseProtocol) {
        self.network = network
        self.decoder = decoder
        
        self.productId = 1
        self.page = 1
    }

    // MARK: - Public Methods

    /// Fetch async data.
    /// The decoded models are written to the date property.
    func fetchAsync() {
        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.reviews(self.productId, self.page)) {
                // Отключил пока вызывается в appDelegate, так как там не сохраняется
                // [weak self]
                result in

                // guard let self = self else { return }

                do {
                    switch result {
                    case .success(let data):
                        let response = try self.decoder.decode(data: data, model: Model.self)
                        self.data = response
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

    /// Fetch add review.
    /// - Parameter reviewText: text review
    func addReview(_ reviewText: String) {
        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.addReview(self.productId, reviewText)) {
                // Отключил пока вызывается в appDelegate, так как там не сохраняется
                // [weak self]
                result in

                // guard let self = self else { return }

                do {
                    switch result {
                    case .success(let data):
                        let response = try self.decoder.decode(data: data, model: ResponseReviewModel.self)
                        self.data?.items.insert(response, at: 0)
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

    /// Fetch delete review.
    /// - Parameter indexReview: index review
    func deleteReview(_ indexReview: Int) {
        // проверка индекса
        guard indexReview < data?.items.count ?? 0,
                let review = data?.items[indexReview] else { return }

        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.deleteReview(self.productId, review.idReview)) {
                // Отключил пока вызывается в appDelegate, так как там не сохраняется
                // [weak self]
                result in

                // guard let self = self else { return }

                do {
                    switch result {
                    case .success(let data):
                        let response = try self.decoder.decode(data: data, model: ResponseMessageModel.self)
                        self.data?.items.remove(at: indexReview)
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
