//
//  ScrollViewExtension.swift
//  PullToRefresh
//
//  Created by Leo Zhou on 2017/4/30.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit

private var refreshHeaderViewKey: UInt8 = 0
private var refreshFooterViewKey: UInt8 = 0

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
    
    private var spr_refreshFooterView: RefreshFooterView? {
        get {
            return objc_getAssociatedObject(self, &refreshFooterViewKey) as? RefreshFooterView
        }
        set {
            objc_setAssociatedObject(self, &refreshFooterViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            newValue.map { insertSubview($0, at: 0) }
        }
    }
    
    public func spr_addIndicatorHeader(color: UIColor = Default.color,
                                       height: CGFloat = Default.short,
                                       action: @escaping () -> Void) {
        spr_refreshHeaderView = IndicatorHeaderView(color: color, height: height, action: action)
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
    
    public func spr_addGIFHeader(data: Data,
                                 isBig: Bool,
                                 height: CGFloat,
                                 action: @escaping () -> Void) {
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
    
    public func spr_addSuperCatHeader(height: CGFloat = Default.high,
                                      action: @escaping () -> Void) {
        spr_refreshHeaderView = SuperCatHeaderView(height: height, action: action)
    }
    
    public func spr_addIndicatorFooter(color: UIColor = Default.color,
                                       height: CGFloat = Default.footer,
                                       action: @escaping () -> Void) {
        spr_refreshFooterView = IndicatorFooterView(color: color, height: height, action: action)
    }
    
    public func spr_addTextFooter(loadingText: String = Default.loadingText,
                                  font: UIFont = Default.font,
                                  color: UIColor = Default.color,
                                  height: CGFloat = Default.short,
                                  action: @escaping () -> Void) {
        spr_refreshFooterView = TextFooterView(loadingText: loadingText, font: font, color: color, height: height, action: action)
    }
    
    public func spr_addCustomHeader(headerView: RefreshHeaderView) {
        spr_refreshHeaderView = headerView
    }
    
    public func spr_addCustomFooter(footerView: RefreshFooterView) {
        spr_refreshFooterView = footerView
    }
    
    public func spr_beginRefreshing() {
        spr_refreshHeaderView?.beginRefreshing()
    }
    
    public func spr_endRefreshing() {
        spr_refreshHeaderView?.endRefreshing()
        spr_refreshFooterView?.endRefreshing()
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
    static let footer: CGFloat = 40
}
