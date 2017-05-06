//
//  IndicatorHeader.swift
//  SwiftPullToRefresh
//
//  Created by Leo Zhou on 2017/4/30.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit

final class IndicatorHeader: RefreshView {
    private let indicatorItem: IndicatorItem
    
    init(color: UIColor, height: CGFloat, action: @escaping () -> Void) {
        self.indicatorItem = IndicatorItem(color: color)
        super.init(height: height, action: action)
        
        layer.addSublayer(indicatorItem.arrowLayer)
        addSubview(indicatorItem.indicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("SwiftPullToRefresh: init(coder:) has not been implemented")
    }
    
    override func updateState(_ isRefreshing: Bool) {
        indicatorItem.updateState(isRefreshing)
    }
    
    override func updateProgress(_ progress: CGFloat) {
        indicatorItem.updateProgress(progress)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        indicatorItem.arrowLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        indicatorItem.indicator.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
}
