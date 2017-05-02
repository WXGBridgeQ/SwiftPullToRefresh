//
//  RefreshBaseView.swift
//  PullToRefresh
//
//  Created by Leo Zhou on 2017/4/30.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit

open class RefreshBaseView: UIView {
    var scrollView: UIScrollView? {
        return superview as? UIScrollView
    }
    
    private var panGestureRecognizer: UIPanGestureRecognizer?
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        scrollView?.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset))
        panGestureRecognizer?.removeObserver(self, forKeyPath: #keyPath(UIPanGestureRecognizer.state))
    }
    
    override open func didMoveToSuperview() {
        scrollView?.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), context: nil)
        panGestureRecognizer = scrollView?.panGestureRecognizer
        panGestureRecognizer?.addObserver(self, forKeyPath: #keyPath(UIPanGestureRecognizer.state), context: nil)
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
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        fatalError("SwiftPullToRefresh: should use RefreshHeaderView or RefreshFooterView")
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView) {
        fatalError("SwiftPullToRefresh: should use RefreshHeaderView or RefreshFooterView")
    }
}
