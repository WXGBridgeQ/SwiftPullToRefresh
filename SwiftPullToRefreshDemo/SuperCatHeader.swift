//
//  SuperCatHeader.swift
//  SwiftPullToRefreshDemo
//
//  Created by Leo Zhou on 2017/4/30.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit
import SwiftPullToRefresh

final class SuperCatHeader: RefreshView {
    private var refreshItems: [RefreshItem] = []
    private var signRefreshItem: RefreshItem!
    private var isSignVisible = false
    
    override func updateState(_ isRefreshing: Bool) {
        if isRefreshing {
            showSign(false)
            
            // Animate cat and cape
            let cape = refreshItems[5].view
            let cat = refreshItems[4].view
            
            cape.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 32)
            cat.transform = CGAffineTransform(translationX: 1.0, y: 0)
            
            UIView.animate(withDuration: 0.2, delay: 0, options: [.repeat, .autoreverse], animations: {
                cape.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 32)
                cat.transform = CGAffineTransform(translationX: -1.0, y: 0)
            }, completion: nil)
            
            // Animate ground and buildings
            let buildings = refreshItems[0].view
            let ground = refreshItems[2].view
            
            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
                ground.center.y += self.height
                buildings.center.y += self.height
            }, completion: nil)
        } else {
            let cape = refreshItems[5].view
            let cat = refreshItems[4].view
            cape.transform = .identity
            cat.transform = .identity
            cape.layer.removeAllAnimations()
            cat.layer.removeAllAnimations()
        }
    }
    
    override func updateProgress(_ progress: CGFloat) {
        let value = progress * 0.7 + 0.2
        backgroundColor = UIColor(red: value, green: value, blue: value, alpha: 1.0)
        
        refreshItems.forEach { $0.updateViewPositionForPercentage(progress) }
        
        showSign(progress == 1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupRefreshItems()
    }
    
    private func setupRefreshItems() {
        if !refreshItems.isEmpty { return }
        
        let bundle = Bundle(for: type(of: self))
        
        let groundImageView = UIImageView(image: UIImage(named: "ground", in: bundle, compatibleWith: nil))
        let buildingsImageView = UIImageView(image: UIImage(named: "buildings", in: bundle, compatibleWith: nil))
        let sunImageView = UIImageView(image: UIImage(named: "sun", in: bundle, compatibleWith: nil))
        let catImageView = UIImageView(image: UIImage(named: "cat", in: bundle, compatibleWith: nil))
        let capeBackImageView = UIImageView(image: UIImage(named: "cape_back", in: bundle, compatibleWith: nil))
        let capeFrontImageView = UIImageView(image: UIImage(named: "cape_front", in: bundle, compatibleWith: nil))
        
        refreshItems = [
            RefreshItem(view: buildingsImageView, centerEnd: CGPoint(x: bounds.midX, y: bounds.height - groundImageView.bounds.height - buildingsImageView.bounds.midY), parallaxRatio: 1.5, sceneHeight: height),
            RefreshItem(view: sunImageView, centerEnd: CGPoint(x: bounds.width * 0.1, y: bounds.height - groundImageView.bounds.height - sunImageView.bounds.height), parallaxRatio: 3, sceneHeight: height),
            RefreshItem(view: groundImageView, centerEnd: CGPoint(x: bounds.midX, y: bounds.height - groundImageView.bounds.midY), parallaxRatio: 0.5, sceneHeight: height),
            RefreshItem(view: capeBackImageView, centerEnd: CGPoint(x: bounds.midX, y: bounds.height - groundImageView.bounds.midY - capeBackImageView.bounds.midY), parallaxRatio: -1, sceneHeight: height),
            RefreshItem(view: catImageView, centerEnd: CGPoint(x: bounds.midX, y: bounds.height - groundImageView.bounds.midY - catImageView.bounds.midY), parallaxRatio: 1, sceneHeight: height),
            RefreshItem(view: capeFrontImageView, centerEnd: CGPoint(x: bounds.midX, y: bounds.height - groundImageView.bounds.midY - capeFrontImageView.bounds.midY), parallaxRatio: -1, sceneHeight: height)
        ]
        
        refreshItems.forEach { addSubview($0.view) }
        
        let signImageView = UIImageView(image: UIImage(named: "sign", in: bundle, compatibleWith: nil))
        signRefreshItem = RefreshItem(view: signImageView, centerEnd: CGPoint(x: bounds.midX, y: bounds.height - signImageView.bounds.midY), parallaxRatio: 0.5, sceneHeight: height)
        addSubview(signImageView)
    }
    
    private func showSign(_ show: Bool) {
        if isSignVisible == show { return }
        isSignVisible = show
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
            self.signRefreshItem.updateViewPositionForPercentage(show ? 1 : 0)
        }, completion: nil)
    }
}

private final class RefreshItem {
    private var centerStart: CGPoint
    private var centerEnd: CGPoint
    unowned var view: UIView
    
    init(view: UIView, centerEnd: CGPoint, parallaxRatio: CGFloat, sceneHeight: CGFloat) {
        self.view = view
        self.centerEnd = centerEnd
        centerStart = CGPoint(x: centerEnd.x, y: centerEnd.y + (parallaxRatio * sceneHeight))
        self.view.center = centerStart
    }
    
    func updateViewPositionForPercentage(_ percentage: CGFloat) {
        view.center = CGPoint(x: centerStart.x + (centerEnd.x - centerStart.x) * percentage, y: centerStart.y + (centerEnd.y - centerStart.y) * percentage)
    }
}
