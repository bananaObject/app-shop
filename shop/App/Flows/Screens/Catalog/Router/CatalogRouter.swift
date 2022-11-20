//
//  CatalogRouter.swift
//  shop
//
//  Created by Ke4a on 10.11.2022.
//

import UIKit

/// Router protocol for presenter "Catalog". Navigating between screens.
protocol CatalogRouterInput {
    /// Open the screen with registration through the navigation controller.
    /// - Parameters:
    ///   - id: Product id.
    func openProductInfo(_ id: Int)
}

/// Router for presenter "Catalog". Navigating between screens.
class CatalogRouter: CatalogRouterInput {
    // MARK: - Public Properties

    /// Screen controller.
    weak var controller: UIViewController?

    func openProductInfo(_ id: Int) {
        let vc = AppModuleBuilder.productInfoBuild(id)
        vc.modalPresentationStyle = .fullScreen
        controller?.navigationController?.pushViewController(vc, animated: true)
    }
}
