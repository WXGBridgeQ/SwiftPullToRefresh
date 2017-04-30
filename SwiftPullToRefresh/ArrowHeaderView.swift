//
//  ArrowHeaderView.swift
//  PullToRefresh
//
//  Created by Leo Zhou on 2017/4/30.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit

final class ArrowHeaderView: RefreshHeaderView {
    private let arrowItem: ArrowItem
    
    init(color: UIColor, height: CGFloat, action: @escaping () -> Void) {
        self.arrowItem = ArrowItem(color: color)
        super.init(height: height, action: action)
        
        layer.addSublayer(arrowItem.arrowLayer)
        addSubview(arrowItem.indicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateRefreshState(_ isRefreshing: Bool) {
        arrowItem.updateRefreshState(isRefreshing)
    }
    
    override func updateProgress(_ progress: CGFloat) {
        arrowItem.updateProgress(progress)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        arrowItem.arrowLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        arrowItem.indicator.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
}
