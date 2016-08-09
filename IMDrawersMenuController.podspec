Pod::Spec.new do |s|
  s.name         = "IMDrawersMenuController"
  s.version      = "1.0.0"
  s.summary      = "iOS custom menu controller with drawers."
  s.homepage     = "https://github.com/imilakovic/IMDrawersMenuController"
  s.license      = {
    :type => 'MIT',
    :file => 'LICENSE'
  }
  s.author       = {
    "Igor Milakovic" => "igor.milakovic@gmail.com"
  }
  s.platform     = :ios, '7.0'
  s.source       = {
    :git => "https://github.com/imilakovic/IMDrawersMenuController.git",
    :tag => "v1.0.0"
  }
  s.source_files = 'IMDrawersMenuController', 'IMDrawersMenuController/**/*.{h,m}'
  s.requires_arc = true
end
