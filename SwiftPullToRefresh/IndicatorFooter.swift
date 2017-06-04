//
//  IndicatorFooter.swift
//  SwiftPullToRefresh
//
//  Created by Leo Zhou on 2017/5/1.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit

final class IndicatorFooter: RefreshView {
    private let indicatorItem = IndicatorItem()

    private let isAuto: Bool

    init(height: CGFloat, isAuto: Bool = false, action: @escaping () -> Void) {
        self.isAuto = isAuto
        super.init(height: height, style: isAuto ? .autoFooter : .footer, action: action)

        if !isAuto {
            layer.addSublayer(indicatorItem.arrowLayer)
        }

        addSubview(indicatorItem.indicator)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("SwiftPullToRefresh: init(coder:) has not been implemented")
    }

    override func didUpdateState(_ isRefreshing: Bool) {
        indicatorItem.didUpdateState(isRefreshing)
    }

    override func didUpdateProgress(_ progress: CGFloat) {
        indicatorItem.didUpdateProgress(progress, isFooter: true)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let center = CGPoint(x: bounds.midX, y: bounds.midY)

        if !isAuto {
            indicatorItem.arrowLayer.position = center
        }

        indicatorItem.indicator.center = center
    }
}
