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
    
    /// Indicator style header
    ///
    /// - Parameters:
    ///   - color: indicator color, default is (R:0, G:0, B:0, A:0.8)
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
    public func spr_addIndicatorHeader(color: UIColor = Default.color,
                                       height: CGFloat = Default.short,
                                       action: @escaping () -> Void) {
        spr_refreshHeaderView = IndicatorHeaderView(color: color, height: height, action: action)
    }
    
    /// Text style header
    ///
    /// - Parameters:
    ///   - loadingText: text display for refreshing, default is 'Loading...'
    ///   - pullingText: text display for dragging when don't reach the trigger, default is 'Pull down to refresh'
    ///   - releaseText: text display for dragging when reach the trigger, default is 'Release to refresh'
    ///   - font: text font, default is System 14.0
    ///   - color: color for indicator and text, default is (R:0, G:0, B:0, A:0.8)
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
    public func spr_addTextHeader(loadingText: String = Default.loadingText,
                                  pullingText: String = Default.pullingText,
                                  releaseText: String = Default.releaseText,
                                  font: UIFont = Default.font,
                                  color: UIColor = Default.color,
                                  height: CGFloat = Default.short,
                                  action: @escaping () -> Void) {
        spr_refreshHeaderView = TextHeaderView(loadingText: loadingText, pullingText: pullingText, releaseText: releaseText, font: font, color: color, height: height, action: action)
    }
    
    /// GIF style header
    ///
    /// - Parameters:
    ///   - data: data for the GIF file
    ///   - isBig: whether the GIF is displayed with full width
    ///   - height: refresh view height and also the trigger requirement
    ///   - action: refresh action
    public func spr_addGIFHeader(data: Data,
                                 isBig: Bool,
                                 height: CGFloat,
                                 action: @escaping () -> Void) {
        spr_refreshHeaderView = GIFHeaderView(data: data, isBig: isBig, height: height, action: action)
    }
    
    /// GIF + Text style header
    ///
    /// - Parameters:
    ///   - data: data for the GIF file
    ///   - loadingText: text display for refreshing, default is 'Loading...'
    ///   - pullingText: text display for dragging when don't reach the trigger, default is 'Pull down to refresh'
    ///   - releaseText: text display for dragging when reach the trigger, default is 'Release to refresh'
    ///   - font: text font, default is System 14.0
    ///   - color: text color, default is (R:0, G:0, B:0, A:0.8)
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
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
    
    /// SuperCat style header, inspired by RayWenderlich
    /// https://videos.raywenderlich.com/courses/68-scroll-view-school/lessons/18
    ///
    /// - Parameter action: refresh action
    public func spr_addSuperCatHeader(action: @escaping () -> Void) {
        spr_refreshHeaderView = SuperCatHeaderView(height: 120, action: action)
    }
    
    /// Indicator style footer
    ///
    /// - Parameters:
    ///   - color: indicator color, default is (R:0, G:0, B:0, A:0.8)
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
    public func spr_addIndicatorFooter(color: UIColor = Default.color,
                                       height: CGFloat = Default.short,
                                       action: @escaping () -> Void) {
        spr_refreshFooterView = IndicatorFooterView(color: color, height: height, action: action)
    }
    
    /// Text style footer
    ///
    /// - Parameters:
    ///   - loadingText: text display for refreshing, default is 'Loading...'
    ///   - pullingText: text display for dragging when don't reach the trigger, default is 'Pull up to load more'
    ///   - releaseText: text display for dragging when reach the trigger, default is 'Release to load more'
    ///   - font: text font, default is System 14.0
    ///   - color: color for indicator and text, default is (R:0, G:0, B:0, A:0.8)
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
    public func spr_addTextFooter(loadingText: String = Default.loadingText,
                                  pullingText: String = Default.pullingFooterText,
                                  releaseText: String = Default.releaseFooterText,
                                  font: UIFont = Default.font,
                                  color: UIColor = Default.color,
                                  height: CGFloat = Default.short,
                                  action: @escaping () -> Void) {
        spr_refreshFooterView = TextFooterView(loadingText: loadingText, pullingText: pullingText, releaseText: releaseText, font: font, color: color, height: height, action: action)
    }
    
    /// Custom style header
    /// Subclasses need to implement 'updateRefreshState(_:)' and 'updateProgress(_:)' methods
    ///
    /// - Parameter headerView: your custom header subclass
    public func spr_addCustomHeader(headerView: RefreshHeaderView) {
        spr_refreshHeaderView = headerView
    }
    
    /// Custom style footer
    /// Subclasses need to implement 'updateRefreshState(_:)' and 'updateProgress(_:)' methods
    ///
    /// - Parameter footerView: your custom footer subclass
    public func spr_addCustomFooter(footerView: RefreshFooterView) {
        spr_refreshFooterView = footerView
    }
    
    /// begin refreshing
    public func spr_beginRefreshing() {
        spr_refreshHeaderView?.beginRefreshing()
    }
    
    /// end refreshing
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
    static let pullingFooterText = "Pull up to load more"
    static let releaseFooterText = "Release to load more"
    static let high: CGFloat = 120
    static let short: CGFloat = 60
}
