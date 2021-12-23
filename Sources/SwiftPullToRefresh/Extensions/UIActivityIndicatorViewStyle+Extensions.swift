//
//  UIActivityIndicatorViewStyle+Extensions.swift
//  
//
//  Created by Brandon Stillitano on 22/12/21.
//

import Foundation
import UIKit

extension UIActivityIndicatorView.Style {
    /// Version safe method of access `UIActivityIndicatorView.Style.medium`. On versions prior to iOS 13.0 this will return `.gray`.
    static var systemMedium: UIActivityIndicatorView.Style {
        if #available(iOS 13.0, *) {
            return .medium
        } else {
            return .gray
        }
    }
}
