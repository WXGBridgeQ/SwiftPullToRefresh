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
private var tempFooterKey: UInt8 = 0

extension UIScrollView {

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

    private var spr_tempFooter: RefreshView? {
        get {
            return objc_getAssociatedObject(self, &tempFooterKey) as? RefreshView
        }
        set {
            objc_setAssociatedObject(self, &tempFooterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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
    ///   - refreshText: text display for different states
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
    public func spr_setTextHeader(refreshText: RefreshText = headerText,
                                  height: CGFloat = 60,
                                  action: @escaping () -> Void) {
        spr_header = TextView(isHeader: true, refreshText: refreshText, height: height, action: action)
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
    ///   - refreshText: text display for different states
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
    public func spr_setGIFTextHeader(data: Data,
                                     refreshText: RefreshText = headerText,
                                     height: CGFloat = 60,
                                     action: @escaping () -> Void) {
        spr_header = GIFTextHeader(data: data, refreshText: refreshText, height: height, action: action)
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

    /// Begin refreshing with header
    public func spr_beginRefreshing() {
        spr_header?.beginRefreshing()
    }

    /// End refreshing with both header and footer
    public func spr_endRefreshing() {
        spr_header?.endRefreshing()
        spr_footer?.endRefreshing()
    }

    /// End refreshing with footer and remove it
    public func spr_endRefreshingWithNoMoreData() {
        spr_tempFooter = spr_footer
        spr_footer?.endRefreshing { [weak self] in
            self?.spr_footer = nil
        }
    }

    /// Reset footer which is set to no more data
    public func spr_resetNoMoreData() {
        if spr_footer == nil {
            spr_footer = spr_tempFooter
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
    ///   - refreshText: text display for different states
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
    public func spr_setTextFooter(refreshText: RefreshText = footerText,
                                  height: CGFloat = 60,
                                  action: @escaping () -> Void) {
        spr_footer = TextView(isHeader: false, refreshText: refreshText, height: height, action: action)
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
    ///   - loadingText: text display for refreshing
    ///   - height: refresh view height, default is 60
    ///   - action: refresh action
    public func spr_setTextAutoFooter(loadingText: String = loadingText,
                                      height: CGFloat = 60,
                                      action: @escaping () -> Void) {
        spr_footer = TextAutoFooter(loadingText: loadingText, height: height, action: action)
    }


    /// Clear the header
    public func spr_clearHeader() {
        spr_header = nil
    }

    /// Clear the footer
    public func spr_clearFooter() {
        spr_footer = nil
    }

}

/// Text display for different states
public struct RefreshText {
    let loadingText: String
    let pullingText: String
    let releaseText: String

    /// Initialization method
    ///
    /// - Parameters:
    ///   - loadingText: text display for refreshing
    ///   - pullingText: text display for dragging when don't reach the trigger
    ///   - releaseText: text display for dragging when reach the trigger
    public init(loadingText: String, pullingText: String, releaseText: String) {
        self.loadingText = loadingText
        self.pullingText = pullingText
        self.releaseText = releaseText
    }
}

private let isChinese = Locale.preferredLanguages[0].contains("zh-Han")

public let loadingText = isChinese ? "正在加载..." : "Loading..."

public let headerText = RefreshText(
    loadingText: loadingText,
    pullingText: isChinese ? "下拉刷新" : "Pull down to refresh",
    releaseText: isChinese ? "释放刷新" : "Release to refresh"
)

public let footerText = RefreshText(
    loadingText: loadingText,
    pullingText: isChinese ? "上拉加载" : "Pull up to load more",
    releaseText: isChinese ? "释放加载" : "Release to load more"
)
