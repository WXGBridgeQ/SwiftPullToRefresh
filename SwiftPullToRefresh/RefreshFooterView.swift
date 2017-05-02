//
//  RefreshFooterView.swift
//  SwiftPullToRefresh
//
//  Created by Leo Zhou on 2017/4/30.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit

open class RefreshFooterView: RefreshBaseView {
    let height: CGFloat
    
    let action: () -> Void
    
    private var isRefreshing = false {
        didSet {
            updateRefreshState(isRefreshing)
        }
    }
    
    private var progress: CGFloat = 0 {
        didSet {
            updateProgress(progress)
        }
    }
    
    public init(height: CGFloat, action: @escaping () -> Void) {
        self.height = height
        self.action = action
        super.init(frame: .zero)
        updateProgress(progress)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func updateRefreshState(_ isRefreshing: Bool) {
        fatalError("SwiftPullToRefresh: subclasses need to implement the updateRefreshState(_:) method")
    }
    
    open func updateProgress(_ progress: CGFloat) {
        fatalError("SwiftPullToRefresh: subclasses need to implement the updateProgress(_:) method")
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        scrollView?.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize))
    }
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        scrollView?.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), context: nil)
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        
        guard let scrollView = scrollView, keyPath == #keyPath(UIScrollView.contentSize) else { return }
        frame = CGRect(x: 0, y: scrollView.contentSize.height, width: UIScreen.main.bounds.width, height: height)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isRefreshing || scrollView.contentSize.height == 0 { return }
        
        progress = min(1, max(0 , (scrollView.contentOffset.y + scrollView.bounds.height - scrollView.contentSize.height - scrollView.contentInset.bottom) / height))
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView) {
        if isRefreshing || progress < 1 { return }
        beginRefreshing()
    }
    
    func beginRefreshing() {
        if isRefreshing { return }
        
        progress = 1
        isRefreshing = true
        
        UIView.animate(withDuration: 0.4, animations: {
            self.scrollView?.contentInset.bottom += self.height
        }, completion: { _ in
            self.action()
        })
    }
    
    func endRefreshing() {
        if !isRefreshing { return }
        
        UIView.animate(withDuration: 0.4, animations: {
            self.scrollView?.contentInset.bottom -= self.height
        }, completion: { _ in
            self.isRefreshing = false
            self.progress = 0
        })
    }
}
