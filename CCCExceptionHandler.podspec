Pod::Spec.new do |s|
  s.name             = 'CCCExceptionHandler'
  s.version          = '0.0.5'
  s.summary          = 'A library use for catching uncaught exceptions and signals.'

  s.homepage         = 'http://realtouchapp.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors          = { 'Chih-chieh Chang' => 'ccch.realtouch@gmail.com' }
  s.source           = { :git => 'git@github.com:realtouchapp/CCCExceptionHandler.git', :tag => s.version.to_s }
  #s.source           = { :path => '~/Desktop/iOS/Pods/CCCExceptionHandler' }

  s.requires_arc = false
  s.ios.deployment_target = '7.0'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'Classes/**/*.{h,mm}'

  s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'Foundation'
end
