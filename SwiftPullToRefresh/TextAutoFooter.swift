//
//  TextAutoFooter.swift
//  SwiftPullToRefresh
//
//  Created by Leo Zhou on 2017/12/21.
//  Copyright © 2017年 Wiredcraft. All rights reserved.
//

import UIKit

class TextAutoFooter: IndicatorAutoFooter {

    private let loadingText: String

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.label.withAlphaComponent(0.8)
        return label
    }()

    init(loadingText: String, height: CGFloat, action: @escaping () -> Void) {
        self.loadingText = loadingText
        super.init(height: height, action: action)
        addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        indicator.center = center.move(x: -label.bounds.midX - 4)
        label.center = center.move(x: indicator.bounds.midX + 4)
    }

    override func didUpdateState(_ isRefreshing: Bool) {
        super.didUpdateState(isRefreshing)
        label.text = isRefreshing ? loadingText : ""
        label.sizeToFit()
    }

}
