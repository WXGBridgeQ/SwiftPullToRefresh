//
//  ScrollViewExtension.swift
//  PullToRefresh
//
//  Created by Leo Zhou on 2017/4/30.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit

private var refreshHeaderViewKey: UInt8 = 0

public extension UIScrollView {
    private var spr_refreshHeaderView: RefreshHeaderView? {
        get {
            return objc_getAssociatedObject(self, &refreshHeaderViewKey) as? RefreshHeaderView
        }
        set {
            objc_setAssociatedObject(self, &refreshHeaderViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            newValue.map { insertSubview($0, at: 0) }
        }
    }
    
    public func spr_addArrowHeader(color: UIColor = Default.color,
                                   height: CGFloat = Default.short,
                                   action: @escaping () -> Void) {
        spr_refreshHeaderView = ArrowHeaderView(color: color, height: height, action: action)
    }
    
    public func spr_addTextHeader(loadingText: String = Default.loadingText,
                                  pullingText: String = Default.pullingText,
                                  releaseText: String = Default.releaseText,
                                  font: UIFont = Default.font,
                                  color: UIColor = Default.color,
                                  height: CGFloat = Default.short,
                                  action: @escaping () -> Void) {
        spr_refreshHeaderView = TextHeaderView(loadingText: loadingText, pullingText: pullingText, releaseText: releaseText, font: font, color: color, height: height, action: action)
    }
    
    public func spr_addGIFHeader(data: Data, isBig: Bool, height: CGFloat, action: @escaping () -> Void) {
        spr_refreshHeaderView = GIFHeaderView(data: data, isBig: isBig, height: height, action: action)
    }
    
    public func spr_addGIFTextHeader(data: Data,
                                     loadingText: String = Default.loadingText,
                                     pullingText: String = Default.pullingText,
                                     releaseText: String = Default.releaseText,
                                     font: UIFont = Default.font,
                                     color: UIColor = Default.color,
                                     height: CGFloat = Default.short,
                                     action: @escaping () -> Void) {
        spr_refreshHeaderView = GIFTextHeaderView(data: data, loadingText: loadingText, pullingText: pullingText, releaseText: releaseText, font: font, color: color, height: height, action: action)
    }
    
    public func spr_addSuperCatRefresh(height: CGFloat = Default.high,
                                        action: @escaping () -> Void) {
        spr_refreshHeaderView = RefreshSuperCatView(height: height, action: action)
    }
    
    public func spr_addCustomRefresh(refreshView: RefreshHeaderView) {
        spr_refreshHeaderView = refreshView
    }
    
    public func spr_beginRefreshing() {
        spr_refreshHeaderView?.beginRefreshing()
    }
    
    public func spr_endRefreshing() {
        spr_refreshHeaderView?.endRefreshing()
    }
}

// MARK: default values

struct Default {
    static let color: UIColor = UIColor.black.withAlphaComponent(0.8)
    static let font: UIFont = UIFont.systemFont(ofSize: 14)
    static let loadingText = "Loading..."
    static let pullingText = "Pull down to refresh"
    static let releaseText = "Release to refresh"
    
    static let high: CGFloat = 120
    static let short: CGFloat = 60
}
