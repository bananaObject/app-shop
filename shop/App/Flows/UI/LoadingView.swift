//
//  LoadingView.swift
//  shop
//
//  Created by Ke4a on 12.11.2022.
//

import UIKit

extension LoadingView {
    /// Component dot.
    fileprivate class DotLabel: UILabel {
        override init(frame: CGRect) {
            super.init(frame: frame)
            translatesAutoresizingMaskIntoConstraints = false
            text = "●"
            adjustsFontForContentSizeCategory = true
            font = .preferredFont(forTextStyle: .title3)
            textColor = AppStyles.color.main
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

/// View Loading. Animation 3 dots.
final class LoadingView: UIView {
    // MARK: - Visual Components

    /// Array components dots.
    private lazy var dotArray: [DotLabel] = [.init(), .init(), .init()]

    // MARK: - Initializers

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setting UI Method

    /// Settings visual components.
    private func setupUI() {
        self.isHidden = true
        backgroundColor = AppStyles.color.background

        dotArray.forEach { dot in
            addSubview(dot)
        }

        NSLayoutConstraint.activate([
            dotArray[0].centerYAnchor.constraint(equalTo: centerYAnchor),
            dotArray[1].centerYAnchor.constraint(equalTo: centerYAnchor),
            dotArray[2].centerYAnchor.constraint(equalTo: centerYAnchor),

            dotArray[1].centerXAnchor.constraint(equalTo: centerXAnchor),
            dotArray[0].trailingAnchor.constraint(equalTo: dotArray[1].leadingAnchor, constant: -2),
            dotArray[2].leadingAnchor.constraint(equalTo: dotArray[1].trailingAnchor, constant: 2)
        ])
    }

    // MARK: - Public Methods

    /// Enable/Disable animation.
    /// - Parameter work: Animation is enable.
    func animation(_ work: Bool) {
        switch work {
        case true where self.isHidden == true:
            self.isHidden = false
            var delay: Double = 0

            dotArray.forEach { dot in
                UIView.animate(withDuration: 0.4, delay: delay, options: [.repeat, .autoreverse]) {
                    dot.alpha = 0
                }
                delay += 0.2
            }
        case false where self.isHidden == false:
            self.isHidden = true
            dotArray.forEach { dot in
                dot.layer.removeAllAnimations()
                dot.alpha = 1
            }
        default:
           break
        }
    }
}
