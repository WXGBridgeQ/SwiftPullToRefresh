//
//  RefreshArrowView.swift
//  PullToRefresh
//
//  Created by Leo Zhou on 2017/4/30.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit

final class RefreshArrowView: RefreshView {
    var color: UIColor
    
    private lazy var arrowLayer: CAShapeLayer = {
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
    
    private let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    init(color: UIColor, height: CGFloat, action: @escaping () -> Void) {
        self.color = color
        super.init(height: height, action: action)
        
        layer.addSublayer(arrowLayer)
        indicator.color = color
        addSubview(indicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateRefreshState(_ isRefreshing: Bool) {
        arrowLayer.isHidden = isRefreshing
        isRefreshing ? indicator.startAnimating() : indicator.stopAnimating()
    }
    
    override func updateProgress(_ progress: CGFloat) {
        arrowLayer.transform = progress == 1 ? CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1) : CATransform3DIdentity
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        arrowLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        indicator.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
}
