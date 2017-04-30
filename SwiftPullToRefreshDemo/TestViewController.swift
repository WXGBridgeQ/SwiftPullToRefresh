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
            scrollView.spr_addArrowRefresh { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self?.scrollView.spr_endRefreshing()
                }
            }
        case .text:
            scrollView.spr_addTextRefresh { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self?.scrollView.spr_endRefreshing()
                }
            }
        case .gif:
            guard let url = Bundle.main.url(forResource: "demo", withExtension: "gif"), let data = try? Data(contentsOf: url) else { return }
            
            scrollView.spr_addGIFRefresh(data: data) { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self?.scrollView.spr_endRefreshing()
                }
            }
        case .superCat:
            scrollView.spr_addSuperCatRefresh { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self?.scrollView.spr_endRefreshing()
                }
            }
        case .custom:
            let custom = RefershCustomView(height: 60) { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self?.scrollView.spr_endRefreshing()
                }
            }
            scrollView.spr_addCustomRefresh(refreshView: custom)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.spr_beginRefreshing()
    }
}

extension TestViewController {
    enum Style: Int {
        case arrow, text, gif, superCat, custom
    }
}

final class RefershCustomView: RefreshView {
    override func updateRefreshState(_ isRefreshing: Bool) {
        print(isRefreshing)
    }
    
    override func updateProgress(_ progress: CGFloat) {
        print(progress)
    }
}
