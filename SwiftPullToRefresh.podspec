Pod::Spec.new do |s|
  s.name         = "SwiftPullToRefresh"
  s.version      = "1.1.0"
  s.summary      = "An easy way to implement pull-down-to-refresh and pull-up-to-load-more feature based on UIScrollView extension, written in Swift 3."
  s.description  = <<-DESC
                    An easy way to implement pull-down-to-refresh and pull-up-to-load-more feature based on UIScrollView extension, written in Swift 3. Provide default style header and footer controls which you can directly use in your project, and also support for customization. GIF is also supported.
                   DESC
  s.homepage     = "https://github.com/WXGBridgeQ/SwiftPullToRefresh"
  s.license      = "MIT"
  s.author       = { "Leo Zhou" => "wxg.bridgeq@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/WXGBridgeQ/SwiftPullToRefresh.git", :tag => "#{s.version}" }
  s.source_files = "SwiftPullToRefresh/*.{swift}"
end
