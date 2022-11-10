//
//  AppStyles.swift
//  shop
//
//  Created by Ke4a on 29.10.2022.
//
// swiftlint:disable type_name
// swiftlint:disable nesting

import UIKit

/// Application namespace style and settings.
enum AppStyles {
    // MARK: - Color

    /// Application color.
    enum color {
        static var main: UIColor { .gray }
        static var incomplete: UIColor { .lightGray }
        static var complete: UIColor { self.main }
        static var background: UIColor { .white }
    }
}

// MARK: - Font

extension AppStyles {
    /// Application font.
    enum font {
        static var logo: UIFont { .monospacedDigitSystemFont(ofSize: 48, weight: .thin) }
    }
}

// MARK: - Size

extension AppStyles {
    /// Application size.
    enum size {
        static var padding: CGFloat { 8 }

        enum height {
            static var textfield: CGFloat { 40 }
            static var textView: CGFloat { textfield * 3 }
            static var button: CGFloat { textfield * 1.32 }
        }
    }
}
