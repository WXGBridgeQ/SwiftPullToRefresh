//
//  TextView.swift
//  SwiftPullToRefresh
//
//  Created by Leo Zhou on 2017/12/20.
//  Copyright © 2017年 Wiredcraft. All rights reserved.
//

import UIKit

class TextView: IndicatorView {

    private let refreshText: RefreshText

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.label.withAlphaComponent(0.8)
        return label
    }()

    private let isHeader: Bool

    init(isHeader: Bool, refreshText: RefreshText, height: CGFloat, action: @escaping () -> Void) {
        self.isHeader = isHeader
        self.refreshText = refreshText
        super.init(isHeader: isHeader, height: height, action: action)
        addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        arrowLayer.position = center.move(x: -label.bounds.midX - 4)
        indicator.center = center.move(x: -label.bounds.midX - 4)
        label.center = center.move(x: indicator.bounds.midX + 4)
    }

    override func didUpdateState(_ isRefreshing: Bool) {
        super.didUpdateState(isRefreshing)
        label.text = isRefreshing ? refreshText.loadingText : refreshText.pullingText
        label.sizeToFit()
    }

    override func didUpdateProgress(_ progress: CGFloat) {
        super.didUpdateProgress(progress)
        label.text = progress == 1 ? refreshText.releaseText : refreshText.pullingText
        label.sizeToFit()
    }

}

extension CGPoint {
    func move(x: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + x, y: y)
    }
}
