//
//  TextHeaderView.swift
//  PullToRefresh
//
//  Created by Leo Zhou on 2017/4/30.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit

final class TextHeaderView: RefreshHeaderView {
    private let arrowItem: ArrowItem
    
    private let textItem: TextItem
    
    init(loadingText: String, pullingText: String, releaseText: String, font: UIFont, color: UIColor, height: CGFloat, action: @escaping () -> Void) {
        self.arrowItem = ArrowItem(color: color)
        self.textItem = TextItem(loadingText: loadingText, pullingText: pullingText, releaseText: releaseText, font: font, color: color)
        super.init(height: height, action: action)
        
        layer.addSublayer(arrowItem.arrowLayer)
        addSubview(arrowItem.indicator)
        addSubview(textItem.label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateRefreshState(_ isRefreshing: Bool) {
        arrowItem.updateRefreshState(isRefreshing)
        textItem.updateRefreshState(isRefreshing)
    }
    
    override func updateProgress(_ progress: CGFloat) {
        arrowItem.updateProgress(progress)
        textItem.updateProgress(progress)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        arrowItem.arrowLayer.position = CGPoint(x: (bounds.width - textItem.label.bounds.width - 8) * 0.5, y: bounds.midY)
        arrowItem.indicator.center = CGPoint(x: (bounds.width - textItem.label.bounds.width - 8) * 0.5, y: bounds.midY)
        textItem.label.center = CGPoint(x: (bounds.width + arrowItem.indicator.bounds.width + 8) * 0.5, y: bounds.midY)
    }
}
