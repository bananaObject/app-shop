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
        static var text: UIColor { .darkGray }
        static var main: UIColor { .gray }
        static var incomplete: UIColor { .lightGray }
        static var complete: UIColor { self.main }
        static var background: UIColor { .white }
        static var lightGray: UIColor { #colorLiteral(red: 0.9677423835, green: 0.9727136493, blue: 0.9683184028, alpha: 1) }
    }
}

// MARK: - Font

extension AppStyles {
    /// Application font.
    enum font {
        static var logo: UIFont { .monospacedDigitSystemFont(ofSize: 48, weight: .thin) }
        static var tittle: UIFont { .systemFont(ofSize: 32, weight: .light) }
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

// MARK: - Layer

extension AppStyles {
    /// Application layer.
    enum layer {
        static var cornerRadius: CGFloat { 10 }

        enum borderWidth {
            static var incomplete: CGFloat { 0.7 }
            static var complete: CGFloat { 1 }
        }
    }
}
