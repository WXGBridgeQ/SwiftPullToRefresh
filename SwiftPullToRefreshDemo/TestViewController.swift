//
//  TestViewController.swift
//  SwiftPullToRefreshDemo
//
//  Created by Leo Zhou on 2017/12/19.
//  Copyright © 2017年 Wiredcraft. All rights reserved.
//

import UIKit
import SwiftPullToRefresh

class TestViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!

    var refresh: Refresh = .indicatorHeader

    override func viewDidLoad() {
        super.viewDidLoad()
        title = refresh.rawValue

        switch refresh {
        case .indicatorHeader:
            scrollView.spr_setIndicatorHeader { [weak self] in
                self?.action()
            }
        case .textHeader:
            scrollView.spr_setTextHeader { [weak self] in
                self?.action()
            }
        case .smallGIFHeader:
            guard
                let url = Bundle.main.url(forResource: "demo-small", withExtension: "gif"),
                let data = try? Data(contentsOf: url) else { return }
            scrollView.spr_setGIFHeader(data: data) { [weak self] in
                self?.action()
            }
        case .bigGIFHeader:
            guard
                let url = Bundle.main.url(forResource: "demo-big", withExtension: "gif"),
                let data = try? Data(contentsOf: url) else { return }
            scrollView.spr_setGIFHeader(data: data, isBig: true, height: 120) { [weak self] in
                self?.action()
            }
        case .gifTextHeader:
            guard
                let url = Bundle.main.url(forResource: "demo-small", withExtension: "gif"),
                let data = try? Data(contentsOf: url) else { return }
            scrollView.spr_setGIFTextHeader(data: data) { [weak self] in
                self?.action()
            }
        case .superCatHeader:
            let header = SuperCatHeader(style: .header, height: 120) { [weak self] in
                self?.action()
            }
            scrollView.spr_setCustomHeader(header)
        case .indicatorFooter:
            scrollView.spr_setIndicatorFooter { [weak self] in
                self?.action()
            }
        case .textFooter:
            scrollView.spr_setTextFooter { [weak self] in
                self?.action()
            }
        case .indicatorAutoFooter:
            scrollView.spr_setIndicatorAutoFooter { [weak self] in
                self?.action()
            }
        case .textAutoFooter:
            scrollView.spr_setTextAutoFooter { [weak self] in
                self?.action()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.spr_beginRefreshing()
    }

    private func action() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.scrollView.spr_endRefreshing()
        }
    }

}
