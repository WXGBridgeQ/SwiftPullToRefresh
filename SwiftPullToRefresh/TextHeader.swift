//
//  TextHeader.swift
//  SwiftPullToRefresh
//
//  Created by Leo Zhou on 2017/4/30.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit

final class TextHeader: RefreshView {
    private let indicatorItem = IndicatorItem()

    private let textItem: TextItem

    init(textItem: TextItem, height: CGFloat, action: @escaping () -> Void) {
        self.textItem = textItem
        super.init(height: height, action: action)

        layer.addSublayer(indicatorItem.arrowLayer)
        addSubview(indicatorItem.indicator)
        addSubview(textItem.label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("SwiftPullToRefresh: init(coder:) has not been implemented")
    }

    override func didUpdateState(_ isRefreshing: Bool) {
        indicatorItem.didUpdateState(isRefreshing)
        textItem.didUpdateState(isRefreshing)
    }

    override func didUpdateProgress(_ progress: CGFloat) {
        indicatorItem.didUpdateProgress(progress)
        textItem.didUpdateProgress(progress)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        indicatorItem.arrowLayer.position = center.moveLeft(x: textItem.label.bounds.midX + 4)
        indicatorItem.indicator.center = center.moveLeft(x: textItem.label.bounds.midX + 4)
        textItem.label.center = center.moveRight(x: indicatorItem.indicator.bounds.midX + 4)
    }
}

extension CGPoint {
    func moveLeft(x: CGFloat) -> CGPoint {
        return CGPoint(x: self.x - x, y: y)
    }

    func moveRight(x: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + x, y: y)
    }
}
