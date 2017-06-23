![Logo](logo.png)

[![Build Status](https://travis-ci.org/WXGBridgeQ/SwiftPullToRefresh.svg)](https://travis-ci.org/WXGBridgeQ/SwiftPullToRefresh)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/SwiftPullToRefresh.svg)](https://cocoapods.org/pods/SwiftPullToRefresh)
[![Platform](https://img.shields.io/cocoapods/p/SwiftPullToRefresh.svg)](https://cocoapods.org/pods/SwiftPullToRefresh)
[![Language](https://img.shields.io/badge/language-swift-orange.svg)](https://swift.org/)
[![License](https://img.shields.io/badge/license-MIT-000000.svg)](https://github.com/WXGBridgeQ/SwiftPullToRefresh/blob/master/LICENSE)
[![codebeat badge](https://codebeat.co/badges/05eca7f9-68b2-4ca1-aa72-abe7edc5aff2)](https://codebeat.co/projects/github-com-wxgbridgeq-swiftpulltorefresh-master)

# SwiftPullToRefresh

An easy way to implement pull-down-to-refresh and pull-up-to-load-more feature based on UIScrollView extension, written in Swift 3.

Provide default style header and footer controls which you can directly use in your project, and also support for customization. GIF is also supported.

## Example usage

#### Indicator Header

```swift
scrollView.spr_setIndicatorHeader { [weak self] in
    // do your action here
    // self?.scrollView.spr_endRefreshing()
}
```

![](SwiftPullToRefreshDemo/demo01.gif)

#### Text Header

```swift
scrollView.spr_setTextHeader { [weak self] in
    // do your action here
    // self?.scrollView.spr_endRefreshing()
}
```

![](SwiftPullToRefreshDemo/demo02.gif)

#### Small GIF Header

```swift
scrollView.spr_setGIFHeader(data: data, isBig: false, height: 60) { [weak self] in
    // do your action here
    // self?.scrollView.spr_endRefreshing()
}
```

![](SwiftPullToRefreshDemo/demo03.gif)

#### GIF + Text Header

```swift
scrollView.spr_setGIFTextHeader(data: data) { [weak self] in
    // do your action here
    // self?.scrollView.spr_endRefreshing()
}
```

![](SwiftPullToRefreshDemo/demo04.gif)

#### Big GIF Header

```swift
scrollView.spr_setGIFHeader(data: data, isBig: true, height: 120) { [weak self] in
    // do your action here
    // self?.scrollView.spr_endRefreshing()
}
```

![](SwiftPullToRefreshDemo/demo05.gif)

#### Indicator Footer

```swift
scrollView.spr_setIndicatorFooter { [weak self] in
    // do your action here
    // self?.scrollView.spr_endRefreshing()
}
```

or

```swift
scrollView.spr_setIndicatorAutoFooter { [weak self] in
    // do your action here
    // self?.scrollView.spr_endRefreshing()
}
```

![](SwiftPullToRefreshDemo/demo07.gif)

#### Text Footer

```swift
scrollView.spr_setTextFooter { [weak self] in
    // do your action here
    // self?.scrollView.spr_endRefreshing()
}
```

or

```swift
scrollView.spr_setTextAutoFooter { [weak self] in
    // do your action here
    // self?.scrollView.spr_endRefreshing()
}
```

![](SwiftPullToRefreshDemo/demo08.gif)

## Demo

Open and run the SwiftPullToRefreshDemo target in Xcode to see SwiftPullToRefresh in more actions.

## Requirements

* iOS 8.0
* Swift 3.0

## Installation

#### CocoaPods

```
use_frameworks!
pod 'SwiftPullToRefresh'
```

#### Carthage

```
github "WXGBridgeQ/SwiftPullToRefresh"
```

#### Manual

Add SwiftPullToRefresh folder into your project.

## Customization

The framework is very easy to customize the use.

You just need to subclass the `RefreshView` and implement the methods below, then call `spr_setCustomHeader(headerView:)` or `spr_setCustomFooter(footerView:)` with your scrollView.

```swift
class CustomHeaderOrFooter: RefreshView {
    override func didUpdateState(_ isRefreshing: Bool) {
        // customize your view display with refresh state here
    }
    
    override func didUpdateProgress(_ progress: CGFloat) {
        // customize your view display with progress here
    }
}
```

You can also check the code of the super cat refresh which is a custom header in the SwiftPullToRefreshDemo target (Inspired by [RayWenderlich](https://videos.raywenderlich.com/courses/68-scroll-view-school/lessons/18))

![](SwiftPullToRefreshDemo/demo06.gif)

## Contribution

You are welcome to contribute to the project by forking the repo, modifying the code and opening issues or pull requests.

## License

Available under MIT license. See the [LICENSE](https://github.com/WXGBridgeQ/SwiftPullToRefresh/blob/master/LICENSE) for more info.