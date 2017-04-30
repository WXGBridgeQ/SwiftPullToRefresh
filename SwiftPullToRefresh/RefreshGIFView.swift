//
//  RefreshGIFView.swift
//  PullToRefresh
//
//  Created by Leo Zhou on 2017/4/30.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit
import ImageIO

final class RefreshGIFView: RefreshView {
    var data: Data
    
    private let imageView = GIFAnimatedImageView()
    
    init(data: Data, height: CGFloat, action: @escaping () -> Void) {
        self.data = data
        super.init(height: height, action: action)
        
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height)
        imageView.animatedImage = GIFAnimatedImage(data: data)
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateRefreshState(_ isRefreshing: Bool) {
        isRefreshing ? imageView.startAnimating() : imageView.stopAnimating()
    }
    
    override func updateProgress(_ progress: CGFloat) {
        guard let count = imageView.animatedImage?.frameCount else { return }
        imageView.index = Int(CGFloat(count - 1) * progress)
    }
}

// MARK: - GIFRefreshControl
// https://github.com/delannoyk/GIFRefreshControl

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
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        
        let count = CGImageSourceGetCount(source)
        
        for index in 0 ..< count {
            guard let image = CGImageSourceCreateImageAtIndex(source, index, nil), let info = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [String : Any], let gifInfo = info[kCGImagePropertyGIFDictionary as String] as? [String: Any] else { continue }
            
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
        displayLink.add(to: .main, forMode: .commonModes)
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
