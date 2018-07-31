Pod::Spec.new do |s|
  s.name         = "SYCacheFileViewController"
  s.version      = "1.0.0"
  s.summary      = "SYCacheFileViewController used to manager cache file."
  s.homepage     = "https://github.com/potato512/SYCacheFileViewController"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "herman" => "zhangsy757@163.com" }
  s.source       = { :git => "https://github.com/potato512/SYCacheFileViewController.git", :tag => "#{s.version}" }
  s.source_files = "SYCacheFileViewController/*.{h,m}"
  s.resources    = 'SYCacheFileViewController/SYCacheFileImages/*.png'
  s.frameworks   = "UIKit", "CoreFoundation"
  s.requires_arc = true
end