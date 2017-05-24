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
    ///   - color: indicator color, default is (R:0, G:0, B:0, A:0.8)
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
    public func spr_addIndicatorHeader(color: UIColor = Default.color,
                                       height: CGFloat = Default.short,
                                       action: @escaping () -> Void) {
        spr_refreshHeader = IndicatorHeader(color: color, height: height, action: action)
    }

    /// Text header
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
        let textItem = TextItem(loadingText: loadingText, pullingText: pullingText, releaseText: releaseText, font: font, color: color)
        spr_refreshHeader = TextHeader(textItem: textItem, height: height, action: action)
    }

    /// GIF header
    ///
    /// - Parameters:
    ///   - data: data for the GIF file
    ///   - isBig: whether the GIF is displayed with full screen width
    ///   - height: refresh view height and also the trigger requirement
    ///   - action: refresh action
    public func spr_addGIFHeader(data: Data,
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
        spr_refreshHeader = GIFTextHeader(data: data, loadingText: loadingText, pullingText: pullingText, releaseText: releaseText, font: font, color: color, height: height, action: action)
    }

    /// Indicator footer
    ///
    /// - Parameters:
    ///   - color: indicator color, default is (R:0, G:0, B:0, A:0.8)
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
    public func spr_addIndicatorFooter(color: UIColor = Default.color,
                                       height: CGFloat = Default.short,
                                       action: @escaping () -> Void) {
        spr_refreshFooter = IndicatorFooter(color: color, height: height, action: action)
    }

    /// Text footer
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
        let textItem = TextItem(loadingText: loadingText, pullingText: pullingText, releaseText: releaseText, font: font, color: color)
        spr_refreshFooter = TextFooter(textItem: textItem, height: height, action: action)
    }

    /// Indicator auto refresh footer (auto triggered when scroll down to the bottom of the content)
    ///
    /// - Parameters:
    ///   - color: indicator color, default is (R:0, G:0, B:0, A:0.8)
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
    public func spr_addIndicatorAutoFooter(color: UIColor = Default.color,
                                       height: CGFloat = Default.short,
                                       action: @escaping () -> Void) {
        spr_refreshFooter = IndicatorFooter(color: color, height: height, isAuto: true, action: action)
    }

    /// Text auto refresh footer (auto triggered when scroll down to the bottom of the content)
    ///
    /// - Parameters:
    ///   - loadingText: text display for refreshing, default is 'Loading...'
    ///   - pullingText: text display for dragging when don't reach the trigger, default is 'Pull up to load more'
    ///   - releaseText: text display for dragging when reach the trigger, default is 'Release to load more'
    ///   - font: text font, default is System 14.0
    ///   - color: color for indicator and text, default is (R:0, G:0, B:0, A:0.8)
    ///   - height: refresh view height and also the trigger requirement, default is 60
    ///   - action: refresh action
    public func spr_addTextAutoFooter(loadingText: String = Default.loadingText,
                                  pullingText: String = "",
                                  releaseText: String = "",
                                  font: UIFont = Default.font,
                                  color: UIColor = Default.color,
                                  height: CGFloat = Default.short,
                                  action: @escaping () -> Void) {
        let textItem = TextItem(loadingText: loadingText, pullingText: pullingText, releaseText: releaseText, font: font, color: color)
        spr_refreshFooter = TextFooter(textItem: textItem, height: height, isAuto: true, action: action)
    }

    /// Custom header
    /// Subclasses need to implement 'updateState(_:)' and 'updateProgress(_:)' methods
    ///
    /// - Parameter headerView: your custom header subclass
    public func spr_addCustomHeader(headerView: RefreshView) {
        spr_refreshHeader = headerView
    }

    /// Custom footer
    /// Subclasses need to implement 'updateState(_:)' and 'updateProgress(_:)' methods
    ///
    /// - Parameter footerView: your custom footer subclass
    public func spr_addCustomFooter(footerView: RefreshView) {
        spr_refreshFooter = footerView
    }

    /// begin refreshing
    public func spr_beginRefreshing() {
        spr_refreshHeader?.beginRefreshing()
    }

    /// end refreshing
    public func spr_endRefreshing() {
        spr_refreshHeader?.endRefreshing()
        spr_refreshFooter?.endRefreshing()
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
