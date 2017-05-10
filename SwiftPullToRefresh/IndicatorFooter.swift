//
//  IndicatorFooter.swift
//  SwiftPullToRefresh
//
//  Created by Leo Zhou on 2017/5/1.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit

final class IndicatorFooter: RefreshView {
    private let indicatorItem: IndicatorItem
    
    private let isAuto: Bool
    
    init(color: UIColor, height: CGFloat, isAuto: Bool = false, action: @escaping () -> Void) {
        self.isAuto = isAuto
        self.indicatorItem = IndicatorItem(color: color)
        super.init(height: height, style: isAuto ? .autoFooter : .footer, action: action)
        
        if !isAuto {
            layer.addSublayer(indicatorItem.arrowLayer)
        }
        
        addSubview(indicatorItem.indicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("SwiftPullToRefresh: init(coder:) has not been implemented")
    }
    
    override func updateState(_ isRefreshing: Bool) {
        indicatorItem.updateState(isRefreshing)
    }
    
    override func updateProgress(_ progress: CGFloat) {
        indicatorItem.updateProgress(progress, isFooter: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !isAuto {
            indicatorItem.arrowLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        }
        
        indicatorItem.indicator.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
}
