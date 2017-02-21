Pod::Spec.new do |s|
  s.name             = 'CCCExceptionHandler'
  s.version          = '0.0.6'
  s.summary          = 'A library use for catching uncaught exceptions and signals.'

  s.homepage         = 'https://github.com/ccchang0227/CCCExceptionHandler.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors          = { 'Chih-chieh Chang' => 'ccch.realtouch@gmail.com' }
  s.source           = { :git => 'https://github.com/ccchang0227/CCCExceptionHandler.git', :tag => s.version.to_s }

  s.requires_arc = false
  s.ios.deployment_target = '7.0'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'Classes/**/*.{h,mm}'

  s.frameworks = 'Foundation'
end
