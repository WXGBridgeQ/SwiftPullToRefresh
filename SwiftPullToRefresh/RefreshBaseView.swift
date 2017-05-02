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
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        scrollView?.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset))
    }
    
    override open func didMoveToSuperview() {
        scrollView?.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), context: nil)
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let scrollView = scrollView, keyPath == #keyPath(UIScrollView.contentOffset), object as? UIScrollView == scrollView else { return }
        
        scrollViewDidScroll(scrollView)
        if !scrollView.isDragging {
//            if self is RefreshHeaderView {
//                scrollView.setContentOffset(CGPoint(x: 0, y: -scrollView.contentInset.top), animated: true)
//            }
//            if self is RefreshFooterView {
//                scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom), animated: true)
//            }
            scrollViewWillEndDragging(scrollView)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView) {
        
    }
}
