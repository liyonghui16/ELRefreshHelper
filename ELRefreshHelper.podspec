#
# Be sure to run `pod lib lint ELRefreshHelper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ELRefreshHelper'
  s.version          = '0.0.2'
  s.summary          = 'refresh page helper based MJRefresh & EOLNetworking.'
  s.homepage         = 'https://github.com/liyonghui16/ELRefreshHelper'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liyonghui16' => '18335103323@163.com' }
  s.source           = { :git => 'https://github.com/liyonghui16/ELRefreshHelper.git', :tag => s.version }
  s.ios.deployment_target = '8.0'
  s.source_files = 'ELRefreshHelper/Classes/**/*'
  s.dependency 'EOLNetworking', '~> 0.0.10'
  s.dependency 'MJRefresh'
end
