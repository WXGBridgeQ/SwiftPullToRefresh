//
//  ScrollViewExtension.swift
//  SwiftPullToRefresh
//
//  Created by Leo Zhou on 2017/4/30.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit

private var refreshHeaderKey: UInt8 = 0
private var refreshFooterKey: UInt8 = 0

public extension UIScrollView {
    private var spr_refreshHeader: RefreshView? {
        get {
            return objc_getAssociatedObject(self, &refreshHeaderKey) as? RefreshView
        }
        set {
            objc_setAssociatedObject(self, &refreshHeaderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            newValue.map { insertSubview($0, at: 0) }
        }
    }

    private var spr_refreshFooter: RefreshView? {
        get {
            return objc_getAssociatedObject(self, &refreshFooterKey) as? RefreshView
        }
        set {
            objc_setAssociatedObject(self, &refreshFooterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            newValue.map { insertSubview($0, at: 0) }
        }
    }

    /// Indicator header
    ///
    /// - Parameters:
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
    public func spr_setIndicatorHeader(height: CGFloat = Default.short,
                                       action: @escaping () -> Void) {
        spr_refreshHeader = IndicatorHeader(height: height, action: action)
    }

    /// Text header
    ///
    /// - Parameters:
    ///   - loadingText: text display for refreshing, default is 'Loading...'
    ///   - pullingText: text display for dragging when don't reach the trigger, default is 'Pull down to refresh'
    ///   - releaseText: text display for dragging when reach the trigger, default is 'Release to refresh'
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
    public func spr_setTextHeader(loadingText: String = Default.loadingText,
                                  pullingText: String = Default.pullingText,
                                  releaseText: String = Default.releaseText,
                                  height: CGFloat = Default.short,
                                  action: @escaping () -> Void) {
        let textItem = TextItem(loadingText: loadingText, pullingText: pullingText, releaseText: releaseText)
        spr_refreshHeader = TextHeader(textItem: textItem, height: height, action: action)
    }

    /// GIF header
    ///
    /// - Parameters:
    ///   - data: data for the GIF file
    ///   - isBig: whether the GIF is displayed with full screen width
    ///   - height: refresh view height and also the trigger requirement
    ///   - action: refresh action
    public func spr_setGIFHeader(data: Data,
                                 isBig: Bool,
                                 height: CGFloat,
                                 action: @escaping () -> Void) {
        spr_refreshHeader = GIFHeader(data: data, isBig: isBig, height: height, action: action)
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
                                     loadingText: String = Default.loadingText,
                                     pullingText: String = Default.pullingText,
                                     releaseText: String = Default.releaseText,
                                     height: CGFloat = Default.short,
                                     action: @escaping () -> Void) {
        let textItem = TextItem(loadingText: loadingText, pullingText: pullingText, releaseText: releaseText)
        spr_refreshHeader = GIFTextHeader(data: data, textItem: textItem, height: height, action: action)
    }

    /// Indicator footer
    ///
    /// - Parameters:
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
    public func spr_setIndicatorFooter(height: CGFloat = Default.short,
                                       action: @escaping () -> Void) {
        spr_refreshFooter = IndicatorFooter(height: height, action: action)
    }

    /// Text footer
    ///
    /// - Parameters:
    ///   - loadingText: text display for refreshing, default is 'Loading...'
    ///   - pullingText: text display for dragging when don't reach the trigger, default is 'Pull up to load more'
    ///   - releaseText: text display for dragging when reach the trigger, default is 'Release to load more'
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
    public func spr_setTextFooter(loadingText: String = Default.loadingText,
                                  pullingText: String = Default.pullingFooterText,
                                  releaseText: String = Default.releaseFooterText,
                                  height: CGFloat = Default.short,
                                  action: @escaping () -> Void) {
        let textItem = TextItem(loadingText: loadingText, pullingText: pullingText, releaseText: releaseText)
        spr_refreshFooter = TextFooter(textItem: textItem, height: height, action: action)
    }

    /// Indicator auto refresh footer (auto triggered when scroll down to the bottom of the content)
    ///
    /// - Parameters:
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
    public func spr_setIndicatorAutoFooter(height: CGFloat = Default.short,
                                           action: @escaping () -> Void) {
        spr_refreshFooter = IndicatorFooter(height: height, isAuto: true, action: action)
    }

    /// Text auto refresh footer (auto triggered when scroll down to the bottom of the content)
    ///
    /// - Parameters:
    ///   - loadingText: text display for refreshing, default is 'Loading...'
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
    public func spr_setTextAutoFooter(loadingText: String = Default.loadingText,
                                      height: CGFloat = Default.short,
                                      action: @escaping () -> Void) {
        let textItem = TextItem(loadingText: loadingText)
        spr_refreshFooter = TextFooter(textItem: textItem, height: height, isAuto: true, action: action)
    }

    /// Custom header
    /// Inherit from RefreshView
    /// Update the presentation in 'didUpdateState(_:)' and 'didUpdateProgress(_:)' methods
    ///
    /// - Parameter headerView: your custom header inherited from RefreshView
    public func spr_setCustomHeader(headerView: RefreshView) {
        spr_refreshHeader = headerView
    }

    /// Custom footer
    /// Inherit from RefreshView
    /// Update the presentation in 'didUpdateState(_:)' and 'didUpdateProgress(_:)' methods
    ///
    /// - Parameter footerView: your custom footer inherited from RefreshView
    public func spr_setCustomFooter(footerView: RefreshView) {
        spr_refreshFooter = footerView
    }

    /// begin refreshing with header
    public func spr_beginRefreshing() {
        spr_refreshHeader?.beginRefreshing()
    }

    /// end refreshing with both header and footer
    public func spr_endRefreshing() {
        spr_refreshHeader?.endRefreshing()
        spr_refreshFooter?.endRefreshing()
    }

    /// end refreshing with footer and remove it
    ///
    /// - Parameter message: show a label with message below the content, default is nil
    public func spr_endRefreshingWithNoMoreData(message: String? = nil) {
        spr_refreshFooter?.endRefreshing { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.spr_refreshFooter?.removeFromSuperview()
            strongSelf.spr_refreshFooter = nil

            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = UIColor.black.withAlphaComponent(0.8)
            label.text = message
            label.sizeToFit()
            label.center = CGPoint(x: strongSelf.bounds.midX, y: strongSelf.contentSize.height + 24)
            strongSelf.addSubview(label)
        }
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
