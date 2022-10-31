//
//  AppStyles.swift
//  shop
//
//  Created by Ke4a on 29.10.2022.
//

import UIKit

/// Application style and settings.
enum AppStyles {
    // MARK: - Static Methods
    
    static let color = Color()
    static let frame = Frame()
    static let image = Image()
}

extension AppStyles {
    // MARK: - Color

    struct Color {
        let incomplete: UIColor = .lightGray
        let complete: UIColor = .gray
        let background: UIColor = .white
    }

    // MARK: - Image

    struct Image {
        let eyeOpen: String = "eyeOpen"
        let eyeClose: String = "eyeClose"
        let signUp: String = "signUp"
    }
}

// MARK: - Frame

extension AppStyles {
    struct Frame {
        let height = Height()
    }

    struct Height {
        let textfield: CGFloat = 40
    }
}
