//
//  RefreshView.swift
//  PullToRefresh
//
//  Created by Leo Zhou on 2017/4/30.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit

class RefreshView: UIView {
    var height: CGFloat
    
    var action: () -> Void
    
    fileprivate var isRefreshing = false {
        didSet {
            updateRefreshState(isRefreshing)
        }
    }
    
    fileprivate var progress: CGFloat = 0 {
        didSet {
            updateProgress(progress)
        }
    }
    
    private var scrollView: UIScrollView? {
        return superview as? UIScrollView
    }
    
    fileprivate weak var scrollViewDelegate: UIScrollViewDelegate?
    
    init(height: CGFloat, action: @escaping () -> Void) {
        self.height = height
        self.action = action
        super.init(frame: .zero)
        updateProgress(progress)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateRefreshState(_ isRefreshing: Bool) {
        fatalError("PullToRefresh: subclasses need to implement the updateRefreshState(_:) method")
    }
    
    func updateProgress(_ progress: CGFloat) {
        fatalError("PullToRefresh: subclasses need to implement the updateProgress(_:) method")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        scrollView?.removeObserver(self, forKeyPath: #keyPath(UIScrollView.delegate))
    }
    
    override func didMoveToSuperview() {
        frame = CGRect(x: 0, y: -height, width: UIScreen.main.bounds.width, height: height)
        
        scrollViewDelegate = scrollView?.delegate
        scrollView?.delegate = self
        scrollView?.addObserver(self, forKeyPath: #keyPath(UIScrollView.delegate), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let scrollView = scrollView, keyPath == #keyPath(UIScrollView.delegate), object as? UIScrollView == scrollView, !(change?[.newKey] is RefreshView) else { return }
        
        scrollViewDelegate = change?[.newKey] as? UIScrollViewDelegate
        scrollView.delegate = self
    }
    
    func beginRefreshing() {
        if isRefreshing { return }
        
        progress = 1
        isRefreshing = true
        
        UIView.animate(withDuration: 0.4, animations: {
            self.scrollView?.contentOffset.y = -self.height - (self.scrollView?.contentInset.top ?? 0)
            self.scrollView?.contentInset.top += self.height
        }, completion: { _ in
            self.action()
        })
    }
    
    func endRefreshing() {
        if !isRefreshing { return }
        
        UIView.animate(withDuration: 0.4, animations: {
            self.scrollView?.contentInset.top -= self.height
        }, completion: { _ in
            self.isRefreshing = false
            self.progress = 0
        })
    }
}

extension RefreshView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidScroll?(scrollView)
        
        if isRefreshing { return }
        progress = min(1, max(0 , -(scrollView.contentOffset.y + scrollView.contentInset.top) / height))
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollViewDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        
        if isRefreshing || progress < 1 { return }
        beginRefreshing()
        targetContentOffset.pointee.y = -scrollView.contentInset.top
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidZoom?(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollViewDelegate?.viewForZooming?(in: scrollView)
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollViewDelegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollViewDelegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return scrollViewDelegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidScrollToTop?(scrollView)
    }
}
