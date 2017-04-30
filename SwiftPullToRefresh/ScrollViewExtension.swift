//
//  ScrollViewExtension.swift
//  PullToRefresh
//
//  Created by Leo Zhou on 2017/4/30.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit

private var refreshViewKey: UInt8 = 0

public extension UIScrollView {
    private var spr_refreshView: RefreshView? {
        get {
            return objc_getAssociatedObject(self, &refreshViewKey) as? RefreshView
        }
        set {
            objc_setAssociatedObject(self, &refreshViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            newValue.map { insertSubview($0, at: 0) }
        }
    }
    
    public func spr_addArrowRefresh(color: UIColor = Default.color,
                                    height: CGFloat = Default.short,
                                    action: @escaping () -> Void) {
        spr_refreshView = RefreshArrowView(color: color, height: height, action: action)
    }
    
    public func spr_addTextRefresh(loadingText: String = Default.loadingText,
                                   pullingText: String = Default.pullingText,
                                   releaseText: String = Default.releaseText,
                                   font: UIFont = Default.font,
                                   color: UIColor = Default.color,
                                   height: CGFloat = Default.short,
                                   action: @escaping () -> Void) {
        spr_refreshView = RefreshTextView(loadingText: loadingText, pullingText: pullingText, releaseText: releaseText, font: font, color: color, height: height, action: action)
    }
    
    public func spr_addGIFRefresh(data: Data,
                                  isBig: Bool,
                                  height: CGFloat,
                                  action: @escaping () -> Void) {
        spr_refreshView = RefreshGIFView(data: data, isBig: isBig, height: height, action: action)
    }
    
    public func spr_addGIFTextRefresh(data: Data,
                                      loadingText: String = Default.loadingText,
                                      pullingText: String = Default.pullingText,
                                      releaseText: String = Default.releaseText,
                                      font: UIFont = Default.font,
                                      color: UIColor = Default.color,
                                      height: CGFloat = Default.short,
                                      action: @escaping () -> Void) {
        spr_refreshView = RefreshGIFTextView(data: data, loadingText: loadingText, pullingText: pullingText, releaseText: releaseText, font: font, color: color, height: height, action: action)
    }
    
    public func spr_addSuperCatRefresh(height: CGFloat = Default.high,
                                        action: @escaping () -> Void) {
        spr_refreshView = RefreshSuperCatView(height: height, action: action)
    }
    
    public func spr_addCustomRefresh(refreshView: RefreshView) {
        spr_refreshView = refreshView
    }
    
    public func spr_beginRefreshing() {
        spr_refreshView?.beginRefreshing()
    }
    
    public func spr_endRefreshing() {
        spr_refreshView?.endRefreshing()
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
