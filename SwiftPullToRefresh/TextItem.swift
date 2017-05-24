//
//  TextItem.swift
//  SwiftPullToRefresh
//
//  Created by Leo Zhou on 2017/5/1.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit

final class TextItem {
    private let loadingText: String

    private let pullingText: String

    private let releaseText: String

    private let font: UIFont

    let color: UIColor

    let label = UILabel()

    init(loadingText: String, pullingText: String, releaseText: String, font: UIFont, color: UIColor) {
        self.loadingText = loadingText
        self.pullingText = pullingText
        self.releaseText = releaseText
        self.font = font
        self.color = color

        label.textColor = color
        label.font = font
    }

    func updateState(_ isRefreshing: Bool) {
        label.text = isRefreshing ? loadingText : pullingText
        label.sizeToFit()
    }

    func updateProgress(_ progress: CGFloat) {
        label.text = progress == 1 ? releaseText : pullingText
        label.sizeToFit()
    }
}
