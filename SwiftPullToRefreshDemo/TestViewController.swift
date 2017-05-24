//
//  TestViewController.swift
//  SwiftPullToRefresh
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
                self?.action()
            }
        case .textHeader:
            scrollView.spr_addTextHeader { [weak self] in
                self?.action()
            }
        case .smallGIFHeader:
            guard let url = Bundle.main.url(forResource: "demo-small", withExtension: "gif"), let data = try? Data(contentsOf: url) else { return }

            scrollView.spr_addGIFHeader(data: data, isBig: false, height: 60) { [weak self] in
                self?.action()
            }
        case .gifTextHeader:
            guard let url = Bundle.main.url(forResource: "demo-small", withExtension: "gif"), let data = try? Data(contentsOf: url) else { return }

            scrollView.spr_addGIFTextHeader(data: data) { [weak self] in
                self?.action()
            }
        case .bigGIFHeader:
            guard let url = Bundle.main.url(forResource: "demo-big", withExtension: "gif"), let data = try? Data(contentsOf: url) else { return }

            scrollView.spr_addGIFHeader(data: data, isBig: true, height: 120) { [weak self] in
                self?.action()
            }
        case .superCatHeader:
            let superCatHeader = SuperCatHeader(height: 120) { [weak self] in
                self?.action()
            }
            scrollView.spr_addCustomHeader(headerView: superCatHeader)
        case .indicatorFooter:
            scrollView.spr_addIndicatorFooter { [weak self] in
                self?.action()
            }
        case .textFooter:
            scrollView.spr_addTextFooter { [weak self] in
                self?.action()
            }
        case .indicatorAutoFooter:
            scrollView.spr_addIndicatorAutoFooter { [weak self] in
                self?.action()
            }
        case .textAutoFooter:
            scrollView.spr_addTextAutoFooter { [weak self] in
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

extension TestViewController {
    enum Style: Int {
        case indicatorHeader, textHeader, smallGIFHeader, gifTextHeader, bigGIFHeader, superCatHeader, indicatorFooter, textFooter, indicatorAutoFooter, textAutoFooter
    }
}
