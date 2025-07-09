
Pod::Spec.new do |s|
  s.name             = 'NotionSwift'
  s.version          = '0.9.0'
  s.summary          = 'Unofficial Notion SDK for iOS & macOS.'
  s.homepage         = 'https://github.com/chojnac/NotionSwift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Wojciech Chojnacki' => 'me@chojnac.com' }
  s.source           = { :git => 'https://github.com/chojnac/NotionSwift.git', :tag => s.version.to_s }
  
  s.swift_version    = '6.0'
  s.source_files = ['Sources/NotionSwift/**/*']

  s.ios.deployment_target = '18.0'
  s.ios.frameworks = "UIKit"

  s.osx.deployment_target = '15.0'
  s.osx.frameworks = "AppKit"

  # Swift 6 strict concurrency support
  s.pod_target_xcconfig = {
    'SWIFT_UPCOMING_FEATURE_STRICT_CONCURRENCY' => 'YES',
    'SWIFT_STRICT_CONCURRENCY' => 'complete',
    'SWIFT_VERSION' => '6.0'
  }

  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = ['Tests/NotionSwiftTests/**/*']
    test_spec.pod_target_xcconfig = {
      'SWIFT_UPCOMING_FEATURE_STRICT_CONCURRENCY' => 'YES',
      'SWIFT_STRICT_CONCURRENCY' => 'complete',
      'SWIFT_VERSION' => '6.0'
    }
  end

end
