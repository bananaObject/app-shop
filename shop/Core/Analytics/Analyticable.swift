//
//  Analyticable.swift
//  shop
//
//  Created by Ke4a on 25.11.2022.
//

import FirebaseAnalytics
import Foundation

/// Enumeration of analytics.
enum AnalyticsEvent {
    /// Login success/failure..
    /// - Parameter succes: is succec.
    case authorization(_ succes: Bool)
    /// Logout.
    case logout
    /// Added product.
    /// - Parameter id: Product id.
    /// - Parameter qt: Product quantity.
    case addedProductToBasket(_ id: Int, qt: Int)
    /// Removed product.
    /// - Parameter id: Product id.
    /// - Parameter qt: Product quantity.
    case removedProductFromBasket(_ id: Int, qt: Int)
    ///  Browses the "product" screen.
    /// - Parameter id: Product id.
    case watchingProductScreen(_ id: Int)
    ///  Browses the "catalog" screen.
    /// - Parameter id: Product id.
    /// - Parameter category: Product category.
    case watchingCatalogScreen(_ page: Int?, _ category: Int?)
    /// Payment success/failure..
    /// - Parameter succes:Payment is succes.
    case payment(_ succes: Bool)
    /// Added review product.
    /// - Parameter producId: Product id.
    case addedReview(_ producId: Int)
    /// Registration.
    case registration(_ succes: Bool)
    /// Error.
    /// - Parameter error:Error.
    /// - Parameter method:Method error.
    case applicationError(_ error: ErrorForAnalytic)

    /// Analytic key.
    var key: String {
        switch self {
        case .addedProductToBasket:
            return "addedProductToBasket"
        case .removedProductFromBasket:
            return "removedProductFromBasket"
        case .watchingCatalogScreen:
            return "watchingCatalogScreen"
        case .watchingProductScreen:
            return "watchingProductScreen"
        case .payment:
            return "payment"
        case .addedReview:
            return "addedReview"
        case .authorization:
            return "authorization"
        case .logout:
            return "logout"
        case .registration:
            return "registration"
        case .applicationError:
            return "applicationError"
        }
    }
}

/// Protocol that contains the method of sending analytics.
protocol Analyticable {
    /// Sends analytics to firebase.
    /// - Parameter event: What information is transmitted.
    func sendAnalytic(_ event: AnalyticsEvent)
}

extension Analyticable {
    func sendAnalytic(_ event: AnalyticsEvent) {
        var log: [String: Any] = [:]
        let key: String = event.key

        switch event {
        case .watchingCatalogScreen(let page, let category):
            if let page = page {
                log["page"] = page
            }

            if let category = category {
                log["category"] = category
            }
        case .addedProductToBasket(let id, let qt),
                .removedProductFromBasket(let id, let qt):
            log["productId"] = id
            log["qt"] = qt
        case .watchingProductScreen(let id),
               .addedReview(let id):
            log["productId"] = id
        case .payment(let succes),
                .authorization(let succes),
                .registration(let succes):
            log["succes"] = succes
        case .applicationError(let error):
            guard let jsonData = try? JSONEncoder().encode(error) else { return }
            let jsonString = String(data: jsonData, encoding: .utf8)!
            log["error"] = jsonString
        case .logout:
            break
        }

        Analytics.logEvent(key, parameters: log)
    }
}

/// Error struct for Analytics.
struct ErrorForAnalytic: Codable {
    let error: String
    let method: String
    let message: String?
}
