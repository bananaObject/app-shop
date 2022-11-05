//
//  AppStyles.swift
//  shop
//
//  Created by Ke4a on 29.10.2022.
//

import UIKit

/// Application namespace style and settings.
enum AppStyles {
    // MARK: - Static Methods

    /// Application color.
    static var color: Color {
        Color()
    }

    /// Application size.
    static var size: Size {
        Size()
    }

    /// Application font.
    static var font: Font {
        Font()
    }
}

// MARK: - Color

extension AppStyles {
    struct Color {
        var main: UIColor { .gray }
        var incomplete: UIColor { .lightGray }
        var complete: UIColor { self.main }
        var background: UIColor { .white }
    }
}

// MARK: - Font

extension AppStyles {
    struct Font {
        var logo: UIFont { .monospacedDigitSystemFont(ofSize: 48, weight: .thin) }
    }
}

// MARK: - Size

extension AppStyles {
    struct Size {
        var padding: CGFloat { 8 }
        var height: Height { Height() }
    }

    struct Height {
        var textfield: CGFloat { 40 }
        var textView: CGFloat { textfield * 3 }
        var button: CGFloat { textfield * 1.32 }
    }
}
