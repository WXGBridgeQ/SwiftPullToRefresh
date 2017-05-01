//
//  TextFooterView.swift
//  SwiftPullToRefresh
//
//  Created by Leo Zhou on 2017/5/1.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit

final class TextFooterView: RefreshFooterView {
    private let indicatorItem: IndicatorItem
    
    private let textItem: TextItem
    
    init(loadingText: String, font: UIFont, color: UIColor, height: CGFloat, action: @escaping () -> Void) {
        self.indicatorItem = IndicatorItem(color: color)
        self.textItem = TextItem(loadingText: loadingText, pullingText: "", releaseText: "", font: font, color: color)
        super.init(height: height, action: action)
        
        addSubview(indicatorItem.indicator)
        addSubview(textItem.label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateRefreshState(_ isRefreshing: Bool) {
        indicatorItem.updateRefreshState(isRefreshing)
        textItem.updateRefreshState(isRefreshing)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        indicatorItem.indicator.center = CGPoint(x: (bounds.width - textItem.label.bounds.width - 8) * 0.5, y: bounds.midY)
        textItem.label.center = CGPoint(x: (bounds.width + indicatorItem.indicator.bounds.width + 8) * 0.5, y: bounds.midY)
    }
}
