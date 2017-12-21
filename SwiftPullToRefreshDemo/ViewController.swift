//
//  ViewController.swift
//  SwiftPullToRefreshDemo
//
//  Created by Leo Zhou on 2017/12/19.
//  Copyright © 2017年 Wiredcraft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Refresh.all.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = Refresh.all[indexPath.row].rawValue
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = storyboard!.instantiateViewController(withIdentifier: "TestViewController") as! TestViewController
        vc.refresh = Refresh.all[indexPath.row]
        navigationController!.pushViewController(vc, animated: true)
    }

}

enum Refresh: String {
    case indicatorHeader = "Indicator Header"
    case textHeader = "Indicator + Text Header"
    case smallGIFHeader = "Small GIF Header"
    case bigGIFHeader = "Big GIF Header"
    case gifTextHeader = "GIF + Text Header"
    case superCatHeader = "SuperCat Custom Header"
    case indicatorFooter = "Indicator Footer"
    case textFooter = "Indicator + Text Footer"
    case indicatorAutoFooter = "Indicator Auto Footer"
    case textAutoFooter = "Indicator + Text Auto Footer"

    static let all: [Refresh] = [.indicatorHeader, .textHeader, .smallGIFHeader, .bigGIFHeader, .gifTextHeader, .superCatHeader, .indicatorFooter, .textFooter, .indicatorAutoFooter, .textAutoFooter]
}
