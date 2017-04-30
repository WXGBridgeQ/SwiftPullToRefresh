//
//  ArrowItem.swift
//  SwiftPullToRefresh
//
//  Created by Leo Zhou on 2017/4/30.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit

final class ArrowItem {
    private let color: UIColor
    
    lazy var arrowLayer: CAShapeLayer = {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 8))
        path.addLine(to: CGPoint(x: 0, y: -8))
        path.move(to: CGPoint(x: 0, y: 8))
        path.addLine(to: CGPoint(x: 5.66, y: 2.34))
        path.move(to: CGPoint(x: 0, y: 8))
        path.addLine(to: CGPoint(x: -5.66, y: 2.34))
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = self.color.cgColor
        layer.lineWidth = 2
        layer.lineCap = kCALineCapRound
        return layer
    }()
    
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    init(color: UIColor) {
        self.color = color
        
        indicator.color = color
    }
    
    func updateRefreshState(_ isRefreshing: Bool) {
        arrowLayer.isHidden = isRefreshing
        isRefreshing ? indicator.startAnimating() : indicator.stopAnimating()
    }
    
    func updateProgress(_ progress: CGFloat) {
        arrowLayer.transform = progress == 1 ? CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1) : CATransform3DIdentity
    }
}
