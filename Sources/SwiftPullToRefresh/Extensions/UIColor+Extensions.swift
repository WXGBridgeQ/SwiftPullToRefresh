//
//  UIColor+Extensions.swift
//  SwiftPullToRefresh
//
//  Created by Brandon Stillitano on 22/12/21.
//  Copyright © 2021 Brandon Stillitano. All rights reserved.
//

import UIKit

extension UIColor {
    /// Version safe method of access `UIColor.label`. On versions prior to iOS 13.0 this will return `.black`.
    static var systemLabel: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return .black
        }
    }
}
