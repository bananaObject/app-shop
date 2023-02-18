//
//  ProductInfoRouter.swift
//  shop
//
//  Created by Ke4a on 13.11.2022.
//

import UIKit

/// Router protocol for presenter "Product info". Navigating between screens.
protocol ProductInfoRouterInput {
    /// Open screen other product.
    /// - Parameter id: Product id.
    func openProductInfo(_ id: Int)
}

/// Router for presenter "Product info". Navigating between screens.
class ProductInfoRouter: ProductInfoRouterInput {
    // MARK: - Public Properties

    weak var controller: UIViewController?

    // MARK: - Public Methods

    func openProductInfo(_ id: Int) {
        let vc = AppModuleBuilder.productInfoBuild(id)
        vc.modalPresentationStyle = .fullScreen
        controller?.navigationController?.pushViewController(vc, animated: true)
    }
}
