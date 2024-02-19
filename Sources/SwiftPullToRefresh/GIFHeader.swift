//
//  GIFHeader.swift
//  SwiftPullToRefresh
//
//  Created by Leo Zhou on 2017/12/21.
//  Copyright © 2017年 Wiredcraft. All rights reserved.
//

import UIKit
import ImageIO
import MobileCoreServices

class GIFHeader: RefreshView {

    private let data: Data
    private let isBig: Bool

    let imageView = GIFAnimatedImageView()

    init(data: Data, isBig: Bool, height: CGFloat, action: @escaping () -> Void) {
        self.data = data
        self.isBig = isBig
        super.init(style: .header, height: height, action: action)

        guard let animatedImage = GIFAnimatedImage(data: data) else {
            print("Error: data is not from an animated image")
            return
        }

        imageView.animatedImage = animatedImage
        addSubview(imageView)

        if isBig {
            imageView.bounds.size = CGSize(width: UIScreen.main.bounds.width, height: height)
            imageView.contentMode = .scaleAspectFill
        } else {
            let ratio = animatedImage.size.width / animatedImage.size.height
            imageView.bounds.size = CGSize(width: ratio * height * 0.67, height: height * 0.67)
            imageView.contentMode = .scaleAspectFit
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }

    override func didUpdateState(_ isRefreshing: Bool) {
        isRefreshing ? imageView.startAnimating() : imageView.stopAnimating()
    }

    override func didUpdateProgress(_ progress: CGFloat) {
        guard let count = imageView.animatedImage?.frameCount else { return }

        if progress == 1 {
            imageView.startAnimating()
        } else {
            imageView.stopAnimating()
            imageView.index = Int(CGFloat(count - 1) * progress)
        }
    }

}

protocol AnimatedImage: class {
    var size: CGSize { get }
    var frameCount: Int { get }

    func frameDurationForImage(at index: Int) -> TimeInterval
    subscript(index: Int) -> UIImage { get }
}

class GIFAnimatedImage: AnimatedImage {

    typealias ImageInfo = (image: UIImage, duration: TimeInterval)
    private var images: [ImageInfo] = []

    var size: CGSize {
        return images.first?.image.size ?? .zero
    }

    var frameCount: Int {
        return images.count
    }

    init?(data: Data) {
        guard
            let source = CGImageSourceCreateWithData(data as CFData, nil),
            let type = CGImageSourceGetType(source)
            else { return nil }

        let isTypeGIF = UTTypeConformsTo(type, kUTTypeGIF)
        let count = CGImageSourceGetCount(source)
        if !isTypeGIF || count <= 1 { return nil }

        for index in 0 ..< count {
            guard
                let image = CGImageSourceCreateImageAtIndex(source, index, nil),
                let info = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [String: Any],
                let gifInfo = info[kCGImagePropertyGIFDictionary as String] as? [String: Any]
                else { continue }

            var duration: Double = 0
            if let unclampedDelay = gifInfo[kCGImagePropertyGIFUnclampedDelayTime as String] as? Double {
                duration = unclampedDelay
            } else {
                duration = gifInfo[kCGImagePropertyGIFDelayTime as String] as? Double ?? 0.1
            }
            if duration <= 0.001 {
                duration = 0.1
            }

            images.append((UIImage(cgImage: image), duration))
        }
    }

    func frameDurationForImage(at index: Int) -> TimeInterval {
        return images[index].duration
    }

    subscript(index: Int) -> UIImage {
        return images[index].image
    }

}

class GIFAnimatedImageView: UIImageView {

    var animatedImage: AnimatedImage? {
        didSet {
            image = animatedImage?[0]
        }
    }

    var index: Int = 0 {
        didSet {
            if index != oldValue {
                image = animatedImage?[index]
            }
        }
    }

    private var animated = false
    private var lastTimestampChange = CFTimeInterval(0)

    private lazy var displayLink: CADisplayLink = {
        let displayLink = CADisplayLink(target: self, selector: #selector(refreshDisplay))
        displayLink.add(to: .main, forMode: .common)
        displayLink.isPaused = true
        return displayLink
    }()

    override func startAnimating() {
        if animated { return }
        displayLink.isPaused = false
        animated = true
    }

    override func stopAnimating() {
        if !animated { return }
        displayLink.isPaused = true
        animated = false
    }

    @objc private func refreshDisplay() {
        guard animated, let animatedImage = animatedImage else { return }

        let currentFrameDuration = animatedImage.frameDurationForImage(at: index)
        let delta = displayLink.timestamp - lastTimestampChange

        if delta >= currentFrameDuration {
            index = (index + 1) % animatedImage.frameCount
            lastTimestampChange = displayLink.timestamp
        }
    }

}
