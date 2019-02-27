Pod::Spec.new do |s|
  s.name         = "SYCacheFileViewController"
  s.version      = "1.2.9"
  s.summary      = "SYCacheFileViewController used to manager cache file."
  s.homepage     = "https://github.com/potato512/SYCacheFileViewController"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "herman" => "zhangsy757@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/potato512/SYCacheFileViewController.git", :tag => "#{s.version}" }
  s.source_files = "SYCacheFileViewController/*.{h,m}"
  s.resources    = "SYCacheFileViewController/SYCacheFileImages/*.png"
  s.frameworks   = "UIKit", "Foundation", "AVFoundation", "AVKit", "QuickLook"
  s.requires_arc = true
end