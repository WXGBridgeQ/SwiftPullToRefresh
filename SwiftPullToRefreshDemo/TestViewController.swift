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
    
    var style: Style = .arrow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch style {
        case .arrow:
            scrollView.spr_addArrowHeader { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.scrollView.spr_endRefreshing()
                }
            }
        case .text:
            scrollView.spr_addTextHeader { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.scrollView.spr_endRefreshing()
                }
            }
        case .gifSmall:
            guard let url = Bundle.main.url(forResource: "demo-small", withExtension: "gif"), let data = try? Data(contentsOf: url) else { return }
            
            scrollView.spr_addGIFHeader(data: data, isBig: false, height: 60) { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.scrollView.spr_endRefreshing()
                }
            }
        case .gifText:
            guard let url = Bundle.main.url(forResource: "demo-small", withExtension: "gif"), let data = try? Data(contentsOf: url) else { return }
            
            scrollView.spr_addGIFTextHeader(data: data) { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.scrollView.spr_endRefreshing()
                }
            }
        case .gifBig:
            guard let url = Bundle.main.url(forResource: "demo-big", withExtension: "gif"), let data = try? Data(contentsOf: url) else { return }
            
            scrollView.spr_addGIFHeader(data: data, isBig: true, height: 120) { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.scrollView.spr_endRefreshing()
                }
            }
        case .superCat:
            scrollView.spr_addSuperCatRefresh { [weak self] in
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
        case arrow, text, gifSmall, gifText, gifBig, superCat
    }
}
