
Pod::Spec.new do |s|
  s.name             = 'TestLib'
  s.version          = '0.0.2'
  s.summary          = 'name'
  s.description      = 'name--'
  s.homepage         = 'https://github.com/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'author' => 'test@163.com' }
  s.source           = { :git => 'https://github.com/', :tag => s.version.to_s }
  
  s.requires_arc = true
  s.platform     = :ios, '8.0'  
  s.ios.deployment_target = '8.0'
  s.swift_version = '5.0'

  s.source_files  = 'Code/**/*'

  s.dependency 'FDFullscreenPopGesture'

end
