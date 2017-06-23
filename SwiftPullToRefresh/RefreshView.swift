//
//  RefreshView.swift
//  SwiftPullToRefresh
//
//  Created by Leo Zhou on 2017/4/30.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit

open class RefreshView: UIView {
    public let height: CGFloat

    private let style: Style

    private let action: () -> Void

    private var isRefreshing = false {
        didSet {
            didUpdateState(isRefreshing)
        }
    }

    private var progress: CGFloat = 0 {
        didSet {
            didUpdateProgress(progress)
        }
    }

    private var scrollView: UIScrollView? {
        return superview as? UIScrollView
    }

    private var panGestureRecognizer: UIPanGestureRecognizer?

    public init(height: CGFloat, style: Style = .header, action: @escaping () -> Void) {
        self.height = height
        self.style = style
        self.action = action
        super.init(frame: .zero)

        didUpdateProgress(progress)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("SwiftPullToRefresh: init(coder:) has not been implemented")
    }

    open func didUpdateState(_ isRefreshing: Bool) {
        // This method should be implemented by subclasses
    }

    open func didUpdateProgress(_ progress: CGFloat) {
        // This method should be implemented by subclasses
    }

    override open func willMove(toSuperview newSuperview: UIView?) {
        scrollView?.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset))
        panGestureRecognizer?.removeObserver(self, forKeyPath: #keyPath(UIPanGestureRecognizer.state))

        switch style {
        case .header:
            break
        case .footer, .autoFooter:
            scrollView?.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize))
        }
    }

    override open func didMoveToSuperview() {
        scrollView?.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), context: nil)
        panGestureRecognizer = scrollView?.panGestureRecognizer
        panGestureRecognizer?.addObserver(self, forKeyPath: #keyPath(UIPanGestureRecognizer.state), context: nil)

        switch style {
        case .header:
            frame = CGRect(x: 0, y: -height, width: UIScreen.main.bounds.width, height: height)
        case .footer, .autoFooter:
            scrollView?.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), context: nil)
        }
    }

    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let scrollView = scrollView else { return }

        if keyPath == #keyPath(UIScrollView.contentOffset) {
            scrollViewDidScroll(scrollView)
        }

        if keyPath == #keyPath(UIPanGestureRecognizer.state) {
            if case .ended = scrollView.panGestureRecognizer.state {
                scrollViewDidEndDragging(scrollView)
            }
        }

        if keyPath == #keyPath(UIScrollView.contentSize) {
            frame = CGRect(x: 0, y: scrollView.contentSize.height, width: UIScreen.main.bounds.width, height: height)
            isHidden = scrollView.contentSize.height <= scrollView.bounds.height
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

    func endRefreshing(completion: (() -> Void)? = nil) {
        guard let scrollView = scrollView, isRefreshing else { return }

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

extension RefreshView {
    public enum Style {
        case header, footer, autoFooter
    }
}
