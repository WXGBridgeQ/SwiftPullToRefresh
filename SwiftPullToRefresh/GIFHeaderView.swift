//
//  GIFHeaderView.swift
//  PullToRefresh
//
//  Created by Leo Zhou on 2017/4/30.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit

final class GIFHeaderView: RefreshHeaderView {
    private let gifItem: GIFItem
    
    init(data: Data, isBig: Bool, height: CGFloat, action: @escaping () -> Void) {
        self.gifItem = GIFItem(data: data, isBig: isBig, height: height)
        super.init(height: height, action: action)
        
        addSubview(gifItem.imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateRefreshState(_ isRefreshing: Bool) {
        gifItem.updateRefreshState(isRefreshing)
    }
    
    override func updateProgress(_ progress: CGFloat) {
        gifItem.updateProgress(progress)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gifItem.imageView.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
}
