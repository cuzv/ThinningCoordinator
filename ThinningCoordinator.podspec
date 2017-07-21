Pod::Spec.new do |s|
  s.name         = "ThinningCoordinator"
  s.version      = "2.1.2"
  s.summary      = "Focus on lighter view controllers."
  s.homepage     = "https://github.com/cuzv/ThinningCoordinator"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Moch Xiao" => "cuzval@gmail.com" }
  s.author = { "Moch Xiao" => "cuzval@gmail.com" }
  s.source       = { :git => "https://github.com/cuzv/ThinningCoordinator.git", :tag => s.version }
  s.source_files  = "ThinningCoordinator/Sources/*.{h,m}"
  s.framework  = "UIKit"
  s.platform     = :ios, "7.0"
  s.requires_arc = true
end
