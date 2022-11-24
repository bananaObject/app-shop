//
//  PayViewController.swift
//  shop
//
//  Created by Ke4a on 23.11.2022.
//

import UIKit
import WebKit

protocol PaymentMoackViewControllerDelegate: AnyObject {
    ///  Payment is successful
    func paymentIsSucces(_ isSucces: Bool)
}

/// Mok payment basket, only instead of entering a card and 3ds secure.
///  You need to see three dogs and then the payment will be credited.
class PaymentMoackViewController: UIViewController {
    // MARK: - Visual Components

    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var payButton: AppButton = {
        let button = AppButton(tittle: """
                            See dogs for payment
                            \(viewsСounter)/\(viewsForPayment)
                            """, activityIndicator: false)
        button.titleLabel?.numberOfLines = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textAlignment = .center
        button.setIsEnable(enable: false)
        return button
    }()

    // MARK: - Public Properties

    /// Controller delegate.
    weak var delegate: (AnyObject & PaymentMoackViewControllerDelegate)?

    // MARK: - Private Properties

    /// Views counter.
    private var viewsСounter = 0

    /// Views for payment.
    private var viewsForPayment = 3

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        startPay()
    }

    deinit {
        // If less than three dog views, then the product is not paid.
        if viewsСounter < 3 {
            dismiss(animated: true) {
                self.delegate?.paymentIsSucces(false)
            }
        } else {
            dismiss(animated: true) {
                self.delegate?.paymentIsSucces(true)
            }
        }
    }

    // MARK: - Setting UI Methods

    /// Settings compont screen.
    private func setupUI() {
        webView.navigationDelegate = self
        view.backgroundColor = AppStyles.color.background

        payButton.addTarget(self, action: #selector(actionPayButton), for: .touchUpInside)

        view.addSubview(payButton)
        NSLayoutConstraint.activate([
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            payButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                               constant: AppStyles.size.padding * 2),
            payButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                constant: -AppStyles.size.padding * 2),
            payButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
        ])


        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                         constant: AppStyles.size.padding * 2),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: payButton.topAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    // MARK: - Private Methods

    /// Start payment.
    private func startPay() {
        guard let url = URL(string: "https://random.dog/") else { return }
        webView.load(URLRequest(url: url))
    }

    // MARK: - Actions

    /// Refreshes the page until the payment terms are met.
    @objc private func actionPayButton() {
        webView.reload()
        payButton.setIsEnable(enable: false)
        // If the dogs for payment are looked at, then the exit.
        if viewsСounter >= viewsForPayment {
            dismiss(animated: true)
        }
    }
}

// MARK: - WKNavigationDelegate

extension PaymentMoackViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        // Show new dogs until the payment condition is met.
        if viewsСounter < viewsForPayment {
            decisionHandler(.allow)
            return
        }

        decisionHandler(.cancel)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewsСounter += 1
        if viewsСounter >= 3 {
            payButton.setTitle("""
                               You good boy, the purchase is paid.
                               Сlick to close.
                               """, for: .normal)
        } else {
            payButton.setTitle("""
                                See dogs for payment
                                \(viewsСounter)/\(viewsForPayment)
                                """, for: .normal)
        }
        payButton.setIsEnable(enable: true)
        return
    }
}
