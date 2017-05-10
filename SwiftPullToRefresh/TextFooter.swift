//
//  TextFooter.swift
//  SwiftPullToRefresh
//
//  Created by Leo Zhou on 2017/5/1.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit

final class TextFooter: RefreshView {
    private let indicatorItem: IndicatorItem
    
    private let textItem: TextItem
    
    private let isAuto: Bool
    
    init(loadingText: String, pullingText: String, releaseText: String, font: UIFont, color: UIColor, height: CGFloat, isAuto: Bool = false, action: @escaping () -> Void) {
        self.isAuto = isAuto
        self.indicatorItem = IndicatorItem(color: color)
        self.textItem = TextItem(loadingText: loadingText, pullingText: pullingText, releaseText: releaseText, font: font, color: color)
        super.init(height: height, style: isAuto ? .autoFooter : .footer, action: action)
        
        layer.addSublayer(indicatorItem.arrowLayer)
        addSubview(indicatorItem.indicator)
        addSubview(textItem.label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("SwiftPullToRefresh: init(coder:) has not been implemented")
    }
    
    override func updateState(_ isRefreshing: Bool) {
        indicatorItem.updateState(isRefreshing)
        textItem.updateState(isRefreshing)
    }
    
    override func updateProgress(_ progress: CGFloat) {
        indicatorItem.updateProgress(progress, isFooter: true)
        textItem.updateProgress(progress)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        indicatorItem.arrowLayer.position = CGPoint(x: (bounds.width - textItem.label.bounds.width - 8) * 0.5, y: bounds.midY)
        indicatorItem.indicator.center = CGPoint(x: (bounds.width - textItem.label.bounds.width - 8) * 0.5, y: bounds.midY)
        textItem.label.center = CGPoint(x: (bounds.width + indicatorItem.indicator.bounds.width + 8) * 0.5, y: bounds.midY)
    }
}
