//
//  CatalogService.swift
//  shop
//
//  Created by Ke4a on 07.09.2022.
//

import Foundation

/// Catalog service.
class CatalogService<Parser: ResponseParserProtocol> {
    // MARK: - Public Properties

    let category: Int
    var data: Parser.Model?

    // MARK: - Private Properties

    private let network: NetworkProtocol
    private let decoder: Parser

    // MARK: - Initialization
    
    init(_ network: NetworkProtocol, _ decoder: Parser) {
        self.network = network
        self.decoder = decoder

        category = 1
    }
    
    // MARK: - Public Methods

    /// Fetch async data.
    /// The decoded models are written to the date property.
    func fetchAsync(_ page: Int) {
        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.catalog(page, self.category)) {
                // Отключил пока вызывается в appDelegate, так как там не сохраняется
                // [weak self]
                result in

                // guard let self = self else { return }

                switch result {
                case .success(let data):
                    guard let response = try? self.decoder.decode(data: data) else { return }
                    self.data = response
                    print(self.data)
                case .failure:
                    break
                }
            }
        }
    }
}
