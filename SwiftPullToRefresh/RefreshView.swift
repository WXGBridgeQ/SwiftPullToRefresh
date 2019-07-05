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

        self.autoresizingMask = [ .flexibleWidth ]
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

    open override func willMove(toWindow newWindow: UIWindow?) {
        if newWindow == nil {
            clearObserver()
        } else {
            guard let scrollView = scrollView else { return }
            setupObserver(scrollView)
        }
    }

    open override func willMove(toSuperview newSuperview: UIView?) {
        guard let scrollView = newSuperview as? UIScrollView, window != nil else {
            clearObserver()
            return
        }
        setupObserver(scrollView)
    }

    private func setupObserver(_ scrollView: UIScrollView) {
        offsetToken = scrollView.observe(\.contentOffset) { [weak self] scrollView, _ in
            self?.scrollViewDidScroll(scrollView)
        }
        stateToken = scrollView.observe(\.panGestureRecognizer.state) { [weak self] scrollView, _ in
            guard scrollView.panGestureRecognizer.state == .ended else { return }
            self?.scrollViewDidEndDragging(scrollView)
        }
        if style == .header {
            frame = CGRect(x: 0, y: -height, width: scrollView.bounds.width, height: height)
        } else {
            sizeToken = scrollView.observe(\.contentSize) { [weak self] scrollView, _ in
                self?.frame = CGRect(x: 0, y: scrollView.contentSize.height, width: scrollView.bounds.width, height: self?.height ?? 0)
                self?.isHidden = scrollView.contentSize.height <= scrollView.bounds.height
            }
        }
    }

    private func clearObserver() {
        offsetToken?.invalidate()
        stateToken?.invalidate()
        sizeToken?.invalidate()
    }

    private func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isRefreshing { return }

        switch style {
        case .header:
            progress = min(1, max(0, -(scrollView.contentOffset.y + scrollView.contentInsetTop) / height))
        case .footer:
            if scrollView.contentSize.height <= scrollView.bounds.height { break }
            progress = min(1, max(0, (scrollView.contentOffset.y + scrollView.bounds.height - scrollView.contentSize.height - scrollView.contentInsetBottom) / height))
        case .autoFooter:
            if scrollView.contentSize.height <= scrollView.bounds.height { break }
            if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInsetBottom {
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
                    scrollView.contentOffset.y = -self.height - scrollView.contentInsetTop
                    scrollView.contentInset.top += self.height
                case .footer:
                    scrollView.contentInset.bottom += self.height
                case .autoFooter:
                    scrollView.contentOffset.y = self.height + scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInsetBottom
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

        DispatchQueue.main.async {
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

}

private extension UIScrollView {
    var contentInsetTop: CGFloat {
        if #available(iOS 11.0, *) {
            return contentInset.top + adjustedContentInset.top
        } else {
            return contentInset.top
        }
    }

    var contentInsetBottom: CGFloat {
        if #available(iOS 11.0, *) {
            return contentInset.bottom + adjustedContentInset.bottom
        } else {
            return contentInset.bottom
        }
    }
}
