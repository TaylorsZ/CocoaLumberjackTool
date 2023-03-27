#
# Be sure to run `pod lib lint CocoaLumberjackTool.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CocoaLumberjackTool'
  s.version          = '2.0.0'
  s.summary          = '真机设备实时显示日志'

  s.description      = "利用CocoaLumberjack将日志实时的显示在设备屏幕上"

  s.homepage         = 'https://github.com/TaylorsZ/CocoaLumberjackTool'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '大奔' => 'zhangs1992@126.com' }
  s.source           = { :git => 'https://github.com/TaylorsZ/CocoaLumberjackTool.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'CocoaLumberjackTool/Classes/**/*'
  s.swift_version = '5.0'
  # s.resource_bundles = {
  #   'CocoaLumberjackTool' => ['CocoaLumberjackTool/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit'
   s.dependency 'CocoaLumberjack/Swift'
   s.dependency 'Texture'
end
