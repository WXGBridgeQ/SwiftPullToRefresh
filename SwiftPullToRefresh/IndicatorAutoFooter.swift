//
//  IndicatorAutoFooter.swift
//  SwiftPullToRefresh
//
//  Created by Leo Zhou on 2017/12/21.
//  Copyright © 2017年 Wiredcraft. All rights reserved.
//

import UIKit

class IndicatorAutoFooter: RefreshView {

    let indicator = UIActivityIndicatorView(style: .medium)

    init(height: CGFloat, action: @escaping () -> Void) {
        super.init(style: .autoFooter, height: height, action: action)
        addSubview(indicator)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        indicator.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }

    override func didUpdateState(_ isRefreshing: Bool) {
        isRefreshing ? indicator.startAnimating() : indicator.stopAnimating()
    }

    override func didUpdateProgress(_ progress: CGFloat) {

    }

}
