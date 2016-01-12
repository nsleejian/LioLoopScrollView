Pod::Spec.new do |s|
  s.name = "LioLoopScrollView"
  s.version = "1.0.0"
  s.summary = "The package of useful tools"
  s.homepage = "http://lio.online"
  s.license = "MIT"
  s.authors = { 'cocoaleespring' => 'cocoaleespring@gmail.com'}
  s.platform = :ios, "9.0"
  s.source = { :git => "https://github.com/lioonline/LioLoopScrollView.git", :tag => s.version }
  s.source_files = 'LioLoopScrollView', 'LioLoopScrollView/LioLoopScrollView/LioLoopView.swift'
  s.requires_arc = true
end
