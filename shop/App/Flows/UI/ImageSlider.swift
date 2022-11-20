//
//  ImageSlider.swift
//  shop
//
//  Created by Ke4a on 13.11.2022.
//

import UIKit

/// Image slider.
class ImageSlider: UIView {
    // MARK: - Visual Components

    /// Horizontal scrollView.
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.isPagingEnabled = true
        return scroll
    }()

    /// Stack image view. Consisting of three or less image view.
    private lazy var imageStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.backgroundColor = AppStyles.color.background
        stack.distribution = .fillEqually
        return stack
    }()

    /// Stack of dots. Equal to the number of images.
    private lazy var dotStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.backgroundColor = AppStyles.color.background
        stack.distribution = .fillEqually
        stack.spacing = 4
        return stack
    }()

    // MARK: - Private Properties

    /// Image array.
    private var images: [UIImage] = [] {
        didSet {
            // Duplicate check.
            if oldValue != images {
                settingsImages(images)
            }
        }
    }

    /// The current index of the picture. Zero index by default.
    private var currentIndex: Int = 0

    // MARK: - Initialization

    init() {
        super.init(frame: .zero)
        scrollView.delegate = self
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setting UI Methods

    /// Settings visual components.
    private func setupUI() {
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])

        scrollView.addSubview(imageStackView)
        NSLayoutConstraint.activate([
            imageStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageStackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])

        addSubview(dotStackView)
        NSLayoutConstraint.activate([
            dotStackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            dotStackView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: AppStyles.size.padding),
            dotStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            dotStackView.leadingAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.leadingAnchor),
            dotStackView.trailingAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    /// Adding image to the stack.
    /// - Parameter image: Image.
    private func addImageToStack(_ image: UIImage) {
        let view = UIImageView()
        view.image = image
        view.contentMode = .scaleAspectFit
        view.backgroundColor = AppStyles.color.background
        view.tintColor = AppStyles.color.incomplete

        imageStackView.addArrangedSubview(view)
    }

    /// Adding dot to the stack.
    private func addDotToStack() {
        let dot = UILabel()
        dot.text = "●"
        dot.adjustsFontForContentSizeCategory = true
        dot.textColor = AppStyles.color.incomplete
        dot.font = .preferredFont(forTextStyle: .caption2)
        dot.backgroundColor = AppStyles.color.background

        dotStackView.addArrangedSubview(dot)
    }

    /// Adjusting the screen after receiving images.
    /// - Parameter images: Images
    private func settingsImages(_ images: [UIImage]) {
        // Screen adjustment based on the number of images.
        if images.count >= 3 {
            images[..<3].forEach { image in
                addImageToStack(image)
            }
        } else {
            images.forEach { image in
                addImageToStack(image)
            }
        }

        // If the number of images >= 3, then three image views are added.
        // If it is less then it is added equal to the number of images.
        NSLayoutConstraint.activate([
            imageStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor,
                                                  multiplier: CGFloat(images.count >= 3 ? 3 : images.count))
        ])
        scrollView.contentSize = imageStackView.frame.size

        // Adding dot to the stack is equal to the number of images.
        for _ in 0..<images.count {
            addDotToStack()
        }

        // Change in the dot of the first image.
        setDotColor(true, index: currentIndex)
    }

    /// Sets the center image by index and moves the scroll to it. Also sets the neighbor images.
    /// - Parameter index: New index image.
    private func setImageStackView(_ index: Int) {
        // The image is not set if it is the first or last image.
        guard index > 0 && index < images.count - 1  else { return }

        guard let centerView = imageStackView.arrangedSubviews[1] as? UIImageView,
              let leftView = imageStackView.arrangedSubviews.first as? UIImageView,
              let rightView = imageStackView.arrangedSubviews.last as? UIImageView else { return }

        DispatchQueue.main.async {
            centerView.image = self.images[index]
            leftView.image = self.images[index - 1]
            rightView.image = self.images[index + 1]
            self.scrollView.setContentOffset(centerView.frame.origin, animated: false)
        }
    }

    /// Changes the color of the dot in the stack.
    /// - Parameters:
    ///   - isEnable: If the image is currently on the screen, then the dot is highlighted.
    ///   - index: Index to stack.
    private func setDotColor(_ isEnable: Bool, index: Int) {
        DispatchQueue.main.async {
            guard let dot = self.dotStackView.arrangedSubviews[index] as? UILabel else { return }
            dot.textColor = isEnable ? AppStyles.color.complete : AppStyles.color.incomplete
            dot.font = isEnable ? .preferredFont(forTextStyle: .footnote) : .preferredFont(forTextStyle: .caption2)
        }
    }

    // MARK: - Public Methods

    /// Transfer images view.
    /// - Parameter images: Images.
    func setImages(_ images: [UIImage]) {
        self.images = images
    }

    // MARK: - Private Methods

    /// Checking which stack view the transition was to.
    private func checkSwipe() {
        let centerOffset = scrollView.contentOffset

        // If there are more than two images.
        if images.count > 2 {
            // Check if there was a swipe. Check if there was a swipe. If was we receive a new index.
            guard let newIndex = checkSwipeWhenThreeOrMore(centerOffset, currentIndex) else { return }

            // Change the image to a new index.
            setImageStackView(newIndex)
            // Change the dot color to the standard color.
            setDotColor(false, index: currentIndex)
            // Change the dot color of the new image.
            setDotColor(true, index: newIndex)
            // Write new index.
            currentIndex = newIndex
        } else {
            // Check if there was a swipe. Check if there was a swipe. If was we receive a new index.
            guard let newIndex = checkSwipeWhenLessThanThree(centerOffset, currentIndex) else { return }

            // In this case, you do not need to change the picture.

            setDotColor(false, index: currentIndex)
            setDotColor(true, index: newIndex)
            currentIndex = newIndex
        }
    }

    /// Checking which swipe was made in the presence of three or more images.
    /// - Parameter centerOffset: Position on the scroll view.
    /// - Parameter currentIndex: Current image index.
    /// - Returns: If there was a swipe, it will return the new index of the selected image.
    private func checkSwipeWhenThreeOrMore(_ centerOffset: CGPoint, _ currentIndex: Int) -> Int? {
        // If the index of the current image is zero and this is the first element of the stack.
        // So there was no swipe.
        guard let firstView = imageStackView.arrangedSubviews.first,
                !(firstView.frame.contains(centerOffset) && currentIndex == 0) else { return nil }

        // If the index of the current image is last and this is the last element of the stack.
        // So there was no swipe.
        guard let lastView = imageStackView.arrangedSubviews.last,
              !(lastView.frame.contains(centerOffset) && currentIndex == images.count - 1) else { return nil }

        // If is the first view or the last image and the center view.
        // So it's a swipe to the left.
        if firstView.frame.contains(centerOffset) ||
            (currentIndex == images.count - 1 && imageStackView.arrangedSubviews[1].frame.contains(centerOffset)) {
            return currentIndex - 1

        // If is the last view or the first image and the center view.
        // So it's a swipe to the right.
        } else if lastView.frame.contains(centerOffset) ||
            (currentIndex == 0 && imageStackView.arrangedSubviews[1].frame.contains(centerOffset)) {
            // Returned a new index.
            return currentIndex + 1
        }

        return nil
    }

    /// Checking which swipe was made in the presence of less than three images.
    /// - Parameter centerOffset: Position on the scroll view.
    /// - Parameter currentIndex: Current image index.
    /// - Returns: If there was a swipe, it will return the new index of the selected image.
    private func checkSwipeWhenLessThanThree(_ centerOffset: CGPoint, _ currentIndex: Int) -> Int? {
        // If the index of the current image is zero and this is the first element of the stack.
        // So there was no swipe.
        guard let firstView = imageStackView.arrangedSubviews.first,
                !(firstView.frame.contains(centerOffset) && currentIndex <= 0)  else { return nil }

        // If the index of the current image is last and this is the last element of the stack.
        // So there was no swipe.
        guard let lastView = imageStackView.arrangedSubviews.last,
                !(lastView.frame.contains(centerOffset) && currentIndex >= images.count - 1) else { return nil }

        // If is the first view. So it's a swipe to the left.
        if firstView.frame.contains(centerOffset) {
            return currentIndex - 1

        // If is the last view. So it's a swipe to the right.
        } else if lastView.frame.contains(centerOffset) {
            return currentIndex + 1
        }

        return nil
    }
}

// MARK: - UIScrollViewDelegate

extension ImageSlider: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        checkSwipe()
    }
}
