//
//  ScrollViewExtension.swift
//  SwiftPullToRefresh
//
//  Created by Leo Zhou on 2017/12/19.
//  Copyright © 2017年 Wiredcraft. All rights reserved.
//

import UIKit

private var headerKey: UInt8 = 0
private var footerKey: UInt8 = 0

public extension UIScrollView {

    private var spr_header: RefreshView? {
        get {
            return objc_getAssociatedObject(self, &headerKey) as? RefreshView
        }
        set {
            spr_header?.removeFromSuperview()
            objc_setAssociatedObject(self, &headerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            newValue.map { insertSubview($0, at: 0) }
        }
    }

    private var spr_footer: RefreshView? {
        get {
            return objc_getAssociatedObject(self, &footerKey) as? RefreshView
        }
        set {
            spr_footer?.removeFromSuperview()
            objc_setAssociatedObject(self, &footerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            newValue.map { insertSubview($0, at: 0) }
        }
    }

    /// Indicator header
    ///
    /// - Parameters:
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
    public func spr_setIndicatorHeader(height: CGFloat = 60,
                                       action: @escaping () -> Void) {
        spr_header = IndicatorView(isHeader: true, height: height, action: action)
    }

    /// Indicator + Text header
    ///
    /// - Parameters:
    ///   - loadingText: text display for refreshing, default is 'Loading...'
    ///   - pullingText: text display for dragging when don't reach the trigger, default is 'Pull down to refresh'
    ///   - releaseText: text display for dragging when reach the trigger, default is 'Release to refresh'
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
    public func spr_setTextHeader(loadingText: String = "Loading...",
                                  pullingText: String = "Pull down to refresh",
                                  releaseText: String = "Release to refresh",
                                  height: CGFloat = 60,
                                  action: @escaping () -> Void) {
        spr_header = TextView(isHeader: true, loadingText: loadingText, pullingText: pullingText, releaseText: releaseText, height: height, action: action)
    }

    /// GIF header
    ///
    /// - Parameters:
    ///   - data: data for the GIF file
    ///   - isBig: whether the GIF is displayed with full screen width
    ///   - height: refresh view height and also the trigger requirement
    ///   - action: refresh action
    public func spr_setGIFHeader(data: Data,
                                 isBig: Bool = false,
                                 height: CGFloat = 60,
                                 action: @escaping () -> Void) {
        spr_header = GIFHeader(data: data, isBig: isBig, height: height, action: action)
    }

    /// GIF + Text header
    ///
    /// - Parameters:
    ///   - data: data for the GIF file
    ///   - loadingText: text display for refreshing, default is 'Loading...'
    ///   - pullingText: text display for dragging when don't reach the trigger, default is 'Pull down to refresh'
    ///   - releaseText: text display for dragging when reach the trigger, default is 'Release to refresh'
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
    public func spr_setGIFTextHeader(data: Data,
                                     loadingText: String = "Loading...",
                                     pullingText: String = "Pull down to refresh",
                                     releaseText: String = "Release to refresh",
                                     height: CGFloat = 60,
                                     action: @escaping () -> Void) {
        spr_header = GIFTextHeader(data: data, loadingText: loadingText, pullingText: pullingText, releaseText: releaseText, height: height, action: action)
    }

    /// Custom header
    /// Inherit from RefreshView
    /// Update the presentation in 'didUpdateState(_:)' and 'didUpdateProgress(_:)' methods
    ///
    /// - Parameter header: your custom header inherited from RefreshView
    public func spr_setCustomHeader(_ header: RefreshView) {
        self.spr_header = header
    }

    /// Custom footer
    /// Inherit from RefreshView
    /// Update the presentation in 'didUpdateState(_:)' and 'didUpdateProgress(_:)' methods
    ///
    /// - Parameter footer: your custom footer inherited from RefreshView
    public func spr_setCustomFooter(_ footer: RefreshView) {
        self.spr_footer = footer
    }

    /// begin refreshing with header
    public func spr_beginRefreshing() {
        spr_header?.beginRefreshing()
    }

    /// end refreshing with both header and footer
    public func spr_endRefreshing() {
        spr_header?.endRefreshing()
        spr_footer?.endRefreshing()
    }

    /// end refreshing with footer and remove it
    public func spr_endRefreshingWithNoMoreData() {
        spr_footer?.endRefreshing { [weak self] in
            self?.spr_footer = nil
        }
    }

    /// Indicator footer
    ///
    /// - Parameters:
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
    public func spr_setIndicatorFooter(height: CGFloat = 60,
                                       action: @escaping () -> Void) {
        spr_footer = IndicatorView(isHeader: false, height: height, action: action)
    }

    /// Indicator + Text footer
    ///
    /// - Parameters:
    ///   - loadingText: text display for refreshing, default is 'Loading...'
    ///   - pullingText: text display for dragging when don't reach the trigger, default is 'Pull up to load more'
    ///   - releaseText: text display for dragging when reach the trigger, default is 'Release to load more'
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
    public func spr_setTextFooter(loadingText: String = "Loading...",
                                  pullingText: String = "Pull up to load more",
                                  releaseText: String = "Release to load more",
                                  height: CGFloat = 60,
                                  action: @escaping () -> Void) {
        spr_footer = TextView(isHeader: false, loadingText: loadingText, pullingText: pullingText, releaseText: releaseText, height: height, action: action)
    }

    /// Indicator auto refresh footer (auto triggered when scroll down to the bottom of the content)
    ///
    /// - Parameters:
    ///   - height: refresh view height, default is 60
    ///   - action: refresh action
    public func spr_setIndicatorAutoFooter(height: CGFloat = 60,
                                           action: @escaping () -> Void) {
        spr_footer = IndicatorAutoFooter(height: height, action: action)
    }

    /// Indicator + Text auto refresh footer (auto triggered when scroll down to the bottom of the content)
    ///
    /// - Parameters:
    ///   - loadingText: text display for refreshing, default is 'Loading...'
    ///   - height: refresh view height, default is 60
    ///   - action: refresh action
    public func spr_setTextAutoFooter(loadingText: String = "Loading...",
                                      height: CGFloat = 60,
                                      action: @escaping () -> Void) {
        spr_footer = TextAutoFooter(loadingText: loadingText, height: height, action: action)
    }

}
