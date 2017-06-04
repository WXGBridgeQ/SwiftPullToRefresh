//
//  GIFTextHeader.swift
//  SwiftPullToRefresh
//
//  Created by Leo Zhou on 2017/4/30.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit

final class GIFTextHeader: RefreshView {
    private let gifItem: GIFItem

    private let textItem: TextItem

    init(data: Data, textItem: TextItem, height: CGFloat, action: @escaping () -> Void) {
        self.gifItem = GIFItem(data: data, isBig: false, height: height)
        self.textItem = textItem
        super.init(height: height, action: action)

        addSubview(gifItem.imageView)
        addSubview(textItem.label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("SwiftPullToRefresh: init(coder:) has not been implemented")
    }

    override func didUpdateState(_ isRefreshing: Bool) {
        gifItem.didUpdateState(isRefreshing)
        textItem.didUpdateState(isRefreshing)
    }

    override func didUpdateProgress(_ progress: CGFloat) {
        gifItem.didUpdateProgress(progress)
        textItem.didUpdateProgress(progress)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        gifItem.imageView.center = center.moveLeft(x: textItem.label.bounds.midX + 4)
        textItem.label.center = center.moveRight(x: gifItem.imageView.bounds.midX + 4)
    }
}
