//
//  TestViewController.swift
//  PullToRefresh
//
//  Created by Leo Zhou on 2017/4/30.
//  Copyright © 2017年 Leo Zhou. All rights reserved.
//

import UIKit
import SwiftPullToRefresh

class TestViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    var style: Style = .indicatorHeader
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch style {
        case .indicatorHeader:
            scrollView.spr_addIndicatorHeader { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.scrollView.spr_endRefreshing()
                }
            }
        case .textHeader:
            scrollView.spr_addTextHeader { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.scrollView.spr_endRefreshing()
                }
            }
        case .smallGIFHeader:
            guard let url = Bundle.main.url(forResource: "demo-small", withExtension: "gif"), let data = try? Data(contentsOf: url) else { return }
            
            scrollView.spr_addGIFHeader(data: data, isBig: false, height: 60) { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.scrollView.spr_endRefreshing()
                }
            }
        case .gifTextHeader:
            guard let url = Bundle.main.url(forResource: "demo-small", withExtension: "gif"), let data = try? Data(contentsOf: url) else { return }
            
            scrollView.spr_addGIFTextHeader(data: data) { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.scrollView.spr_endRefreshing()
                }
            }
        case .bigGIFHeader:
            guard let url = Bundle.main.url(forResource: "demo-big", withExtension: "gif"), let data = try? Data(contentsOf: url) else { return }
            
            scrollView.spr_addGIFHeader(data: data, isBig: true, height: 120) { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.scrollView.spr_endRefreshing()
                }
            }
        case .superCatHeader:
            scrollView.spr_addSuperCatHeader { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.scrollView.spr_endRefreshing()
                }
            }
        case .indicatorFooter:
            scrollView.spr_addIndicatorFooter { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.scrollView.spr_endRefreshing()
                }
            }
        case .textFooter:
            scrollView.spr_addTextFooter { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.scrollView.spr_endRefreshing()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.spr_beginRefreshing()
    }
}

extension TestViewController {
    enum Style: Int {
        case indicatorHeader, textHeader, smallGIFHeader, gifTextHeader, bigGIFHeader, superCatHeader, indicatorFooter, textFooter
    }
}
