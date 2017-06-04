//
//  TextFooter.swift
//  SwiftPullToRefresh
//
//  Created by Leo Zhou on 2017/5/1.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit

final class TextFooter: RefreshView {
    private let indicatorItem = IndicatorItem()

    private let textItem: TextItem

    private let isAuto: Bool

    init(textItem: TextItem, height: CGFloat, isAuto: Bool = false, action: @escaping () -> Void) {
        self.isAuto = isAuto
        self.textItem = textItem
        super.init(height: height, style: isAuto ? .autoFooter : .footer, action: action)

        if !isAuto {
            layer.addSublayer(indicatorItem.arrowLayer)
        }

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
        indicatorItem.didUpdateProgress(progress, isFooter: true)
        textItem.didUpdateProgress(progress)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let center = CGPoint(x: bounds.midX, y: bounds.midY)

        if !isAuto {
            indicatorItem.arrowLayer.position = center.moveLeft(x: textItem.label.bounds.midX + 4)
        }

        indicatorItem.indicator.center = center.moveLeft(x: textItem.label.bounds.midX + 4)
        textItem.label.center = center.moveRight(x: indicatorItem.indicator.bounds.midX + 4)
    }
}
