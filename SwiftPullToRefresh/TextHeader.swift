//
//  TextHeader.swift
//  SwiftPullToRefresh
//
//  Created by Leo Zhou on 2017/4/30.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit

final class TextHeader: RefreshView {
    private let indicatorItem: IndicatorItem

    private let textItem: TextItem

    init(textItem: TextItem, height: CGFloat, action: @escaping () -> Void) {
        self.textItem = textItem
        self.indicatorItem = IndicatorItem(color: textItem.color)
        super.init(height: height, action: action)

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
        indicatorItem.updateProgress(progress)
        textItem.updateProgress(progress)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        indicatorItem.arrowLayer.position = CGPoint(x: (bounds.width - textItem.label.bounds.width - 8) * 0.5, y: bounds.midY)
        indicatorItem.indicator.center = CGPoint(x: (bounds.width - textItem.label.bounds.width - 8) * 0.5, y: bounds.midY)
        textItem.label.center = CGPoint(x: (bounds.width + indicatorItem.indicator.bounds.width + 8) * 0.5, y: bounds.midY)
    }
}
