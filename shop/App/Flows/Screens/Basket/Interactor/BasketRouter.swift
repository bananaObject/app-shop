//
//  BasketRouter.swift
//  shop
//
//  Created by Ke4a on 22.11.2022.
//

import UIKit

/// Router protocol for presenter "Basket". Navigating between screens.
protocol BasketRouterInput {
    /// Open form sheet payment.
    /// - Parameter delegate: Delegate class.
    func openPaymentFormSheet(_ delegate: PaymentMockViewControllerDelegate)
}

/// Router for presenter "Basket". Navigating between screens.
class BasketRouter: BasketRouterInput {
    // MARK: - Public Properties

    /// Screen controller.
    weak var controller: UIViewController?

    func openPaymentFormSheet(_ delegate: PaymentMockViewControllerDelegate) {
        let vc = PaymentMockViewController()
        vc.modalPresentationStyle = .formSheet
        vc.delegate = delegate
        controller?.present(vc, animated: true)
    }
}
