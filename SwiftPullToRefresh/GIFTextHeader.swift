//
//  GIFTextHeader.swift
//  SwiftPullToRefresh
//
//  Created by Leo Zhou on 2017/4/30.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit

final class GIFTextHeader: RefreshView {
    private let gifItem: GIFItem
    
    private let textItem: TextItem
    
    init(data: Data, loadingText: String, pullingText: String, releaseText: String, font: UIFont, color: UIColor, height: CGFloat, action: @escaping () -> Void) {
        self.gifItem = GIFItem(data: data, isBig: false, height: height)
        self.textItem = TextItem(loadingText: loadingText, pullingText: pullingText, releaseText: releaseText, font: font, color: color)
        super.init(height: height, action: action)
        
        addSubview(gifItem.imageView)
        addSubview(textItem.label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("SwiftPullToRefresh: init(coder:) has not been implemented")
    }
    
    override func updateState(_ isRefreshing: Bool) {
        gifItem.updateState(isRefreshing)
        textItem.updateState(isRefreshing)
    }
    
    override func updateProgress(_ progress: CGFloat) {
        gifItem.updateProgress(progress)
        textItem.updateProgress(progress)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gifItem.imageView.center = CGPoint(x: (bounds.width - textItem.label.bounds.width - 8) * 0.5, y: bounds.midY)
        textItem.label.center = CGPoint(x: (bounds.width + gifItem.imageView.bounds.width + 8) * 0.5, y: bounds.midY)
    }
}
