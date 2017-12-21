//
//  RefreshView.swift
//  SwiftPullToRefresh
//
//  Created by Leo Zhou on 2017/12/19.
//  Copyright © 2017年 Wiredcraft. All rights reserved.
//

import UIKit

open class RefreshView: UIView {

    public enum Style {
        case header, footer, autoFooter
    }

    private let style: Style
    public let height: CGFloat
    private let action: () -> Void

    public init(style: Style, height: CGFloat, action: @escaping () -> Void) {
        self.style = style
        self.height = height
        self.action = action
        super.init(frame: .zero)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var isRefreshing = false {
        didSet { didUpdateState(isRefreshing) }
    }

    private var progress: CGFloat = 0 {
        didSet { didUpdateProgress(progress) }
    }

    open func didUpdateState(_ isRefreshing: Bool) {
        fatalError("didUpdateState(_:) has not been implemented")
    }

    open func didUpdateProgress(_ progress: CGFloat) {
        fatalError("didUpdateProgress(_:) has not been implemented")
    }

    private var scrollView: UIScrollView? {
        return superview as? UIScrollView
    }

    private var offsetToken: NSKeyValueObservation?
    private var stateToken: NSKeyValueObservation?
    private var sizeToken: NSKeyValueObservation?

    override open func didMoveToSuperview() {
        guard let scrollView = scrollView else { return }

        offsetToken = scrollView.observe(\.contentOffset) { _, _ in
            self.scrollViewDidScroll(scrollView)
        }
        stateToken = scrollView.panGestureRecognizer.observe(\.state) { _, _ in
            self.scrollViewDidEndDragging(scrollView)
        }

        if style == .header {
            frame = CGRect(x: 0, y: -height, width: UIScreen.main.bounds.width, height: height)
        } else {
            sizeToken = scrollView.observe(\.contentSize) { _, _ in
                self.frame = CGRect(x: 0, y: scrollView.contentSize.height, width: UIScreen.main.bounds.width, height: self.height)
                self.isHidden = scrollView.contentSize.height <= scrollView.bounds.height
            }
        }
    }

    private func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isRefreshing { return }

        switch style {
        case .header:
            progress = min(1, max(0, -(scrollView.contentOffset.y + scrollView.contentInset.top) / height))
        case .footer:
            if scrollView.contentSize.height <= scrollView.bounds.height { break }
            progress = min(1, max(0, (scrollView.contentOffset.y + scrollView.bounds.height - scrollView.contentSize.height - scrollView.contentInset.bottom) / height))
        case .autoFooter:
            if scrollView.contentSize.height <= scrollView.bounds.height { break }
            if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom {
                beginRefreshing()
            }
        }
    }

    private func scrollViewDidEndDragging(_ scrollView: UIScrollView) {
        if isRefreshing || progress < 1 || style == .autoFooter { return }
        beginRefreshing()
    }

    func beginRefreshing() {
        guard let scrollView = scrollView, !isRefreshing else { return }

        progress = 1
        isRefreshing = true
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                switch self.style {
                case .header:
                    scrollView.contentOffset.y = -self.height - scrollView.contentInset.top
                    scrollView.contentInset.top += self.height
                case .footer:
                    scrollView.contentInset.bottom += self.height
                case .autoFooter:
                    scrollView.contentOffset.y = self.height + scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom
                    scrollView.contentInset.bottom += self.height
                }
            }, completion: { _ in
                self.action()
            })
        }
    }

    func endRefreshing(completion: (() -> Void)? = nil) {
        guard let scrollView = scrollView else { return }
        guard isRefreshing else { completion?(); return }

        UIView.animate(withDuration: 0.3, animations: {
            switch self.style {
            case .header:
                scrollView.contentInset.top -= self.height
            case .footer, .autoFooter:
                scrollView.contentInset.bottom -= self.height
            }
        }, completion: { _ in
            self.isRefreshing = false
            self.progress = 0
            completion?()
        })
    }

}
