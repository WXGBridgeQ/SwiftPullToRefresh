//
//  RefreshGIFTextView.swift
//  SwiftPullToRefresh
//
//  Created by Leo Zhou on 2017/4/30.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import Foundation

final class RefreshGIFTextView: RefreshGIFView {
    var loadingText: String
    
    var pullingText: String
    
    var releaseText: String
    
    var font: UIFont
    
    var color: UIColor
    
    private let label = UILabel()
    
    init(data: Data, loadingText: String, pullingText: String, releaseText: String, font: UIFont, color: UIColor, height: CGFloat, action: @escaping () -> Void) {
        self.loadingText = loadingText
        self.pullingText = pullingText
        self.releaseText = releaseText
        self.font = font
        self.color = color
        super.init(data: data, isBig: false, height: height, action: action)
        
        label.textColor = color
        label.font = font
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateRefreshState(_ isRefreshing: Bool) {
        super.updateRefreshState(isRefreshing)
        
        label.text = isRefreshing ? loadingText : pullingText
        label.sizeToFit()
    }
    
    override func updateProgress(_ progress: CGFloat) {
        super.updateProgress(progress)
        
        label.text = progress == 1 ? releaseText : pullingText
        label.sizeToFit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.center = CGPoint(x: (bounds.width - label.bounds.width - 8) * 0.5, y: bounds.midY)
        label.center = CGPoint(x: (bounds.width + imageView.bounds.width + 8) * 0.5, y: bounds.midY)
    }
}
