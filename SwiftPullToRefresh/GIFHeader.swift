//
//  GIFHeader.swift
//  SwiftPullToRefresh
//
//  Created by Leo Zhou on 2017/4/30.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit

final class GIFHeader: RefreshView {
    private let gifItem: GIFItem

    init(data: Data, isBig: Bool, height: CGFloat, action: @escaping () -> Void) {
        self.gifItem = GIFItem(data: data, isBig: isBig, height: height)
        super.init(height: height, action: action)

        addSubview(gifItem.imageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("SwiftPullToRefresh: init(coder:) has not been implemented")
    }

    override func didUpdateState(_ isRefreshing: Bool) {
        gifItem.didUpdateState(isRefreshing)
    }

    override func didUpdateProgress(_ progress: CGFloat) {
        gifItem.didUpdateProgress(progress)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gifItem.imageView.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
}
