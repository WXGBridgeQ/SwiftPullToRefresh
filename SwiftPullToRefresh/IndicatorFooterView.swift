//
//  IndicatorFooterView.swift
//  SwiftPullToRefresh
//
//  Created by Leo Zhou on 2017/5/1.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit

final class IndicatorFooterView: RefreshFooterView {
    private let indicatorItem: IndicatorItem
    
    init(color: UIColor, height: CGFloat, action: @escaping () -> Void) {
        self.indicatorItem = IndicatorItem(color: color)
        super.init(height: height, action: action)
        
        addSubview(indicatorItem.indicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateRefreshState(_ isRefreshing: Bool) {
        indicatorItem.updateRefreshState(isRefreshing)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        indicatorItem.indicator.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
}
