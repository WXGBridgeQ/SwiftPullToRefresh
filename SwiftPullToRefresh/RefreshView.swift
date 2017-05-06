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
    
    private let isFooter: Bool
    
    private let action: () -> Void
    
    private var isRefreshing = false {
        didSet {
            updateState(isRefreshing)
        }
    }
    
    private var progress: CGFloat = 0 {
        didSet {
            updateProgress(progress)
        }
    }
    
    private var scrollView: UIScrollView? {
        return superview as? UIScrollView
    }
    
    private var panGestureRecognizer: UIPanGestureRecognizer?
    
    public init(height: CGFloat, isFooter: Bool = false, action: @escaping () -> Void) {
        self.height = height
        self.isFooter = isFooter
        self.action = action
        super.init(frame: .zero)
        
        updateProgress(progress)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("SwiftPullToRefresh: init(coder:) has not been implemented")
    }
    
    open func updateState(_ isRefreshing: Bool) {
        fatalError("SwiftPullToRefresh: updateState(_:) has not been implemented")
    }
    
    open func updateProgress(_ progress: CGFloat) {
        fatalError("SwiftPullToRefresh: updateProgress(_:) has not been implemented")
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        scrollView?.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset))
        panGestureRecognizer?.removeObserver(self, forKeyPath: #keyPath(UIPanGestureRecognizer.state))
        
        if isFooter {
            scrollView?.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize))
        }
    }
    
    override open func didMoveToSuperview() {
        scrollView?.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), context: nil)
        panGestureRecognizer = scrollView?.panGestureRecognizer
        panGestureRecognizer?.addObserver(self, forKeyPath: #keyPath(UIPanGestureRecognizer.state), context: nil)
        
        if isFooter {
            scrollView?.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), context: nil)
        } else {
            frame = CGRect(x: 0, y: -height, width: UIScreen.main.bounds.width, height: height)
        }
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let scrollView = scrollView else { return }
        
        if keyPath == #keyPath(UIScrollView.contentOffset) {
            scrollViewDidScroll(scrollView)
        }
        
        if keyPath == #keyPath(UIPanGestureRecognizer.state) {
            if case .ended = scrollView.panGestureRecognizer.state {
                scrollViewWillEndDragging(scrollView)
            }
        }
        
        if keyPath == #keyPath(UIScrollView.contentSize) {
            frame = CGRect(x: 0, y: scrollView.contentSize.height, width: UIScreen.main.bounds.width, height: height)
        }
    }
    
    private func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isRefreshing { return }
        
        if isFooter {
            if scrollView.contentSize.height == 0 { return }
            progress = min(1, max(0 , (scrollView.contentOffset.y + scrollView.bounds.height - scrollView.contentSize.height - scrollView.contentInset.bottom) / height))
        } else {
            progress = min(1, max(0 , -(scrollView.contentOffset.y + scrollView.contentInset.top) / height))
        }
    }
    
    private func scrollViewWillEndDragging(_ scrollView: UIScrollView) {
        if isRefreshing || progress < 1 { return }
        beginRefreshing()
    }
    
    func beginRefreshing() {
        guard let scrollView = scrollView, !isRefreshing else { return }
        
        progress = 1
        isRefreshing = true
        
        UIView.animate(withDuration: 0.3, animations: {
            if self.isFooter {
                scrollView.contentInset.bottom += self.height
            } else {
                scrollView.contentOffset.y = -self.height - scrollView.contentInset.top
                scrollView.contentInset.top += self.height
            }
        }, completion: { _ in
            self.action()
        })
    }
    
    func endRefreshing() {
        guard let scrollView = scrollView, isRefreshing else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            if self.isFooter {
                scrollView.contentInset.bottom -= self.height
            } else {
                scrollView.contentInset.top -= self.height
            }
        }, completion: { _ in
            self.isRefreshing = false
            self.progress = 0
        })
    }
}
