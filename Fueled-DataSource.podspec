Pod::Spec.new do |s|
  s.name = 'Fueled-DataSource'
  s.version = '0.6'
  s.summary = 'A Swift framework that helps to deal with sectioned collections of collection items in an MVVM fashion.'
  s.homepage = 'https://github.com/Vadim-Yelagin/DataSource'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.authors = 'Vadim Yelagin'
  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '12.0'
  s.swift_version = '4.2'
  s.source = { :git => 'https://github.com/Vadim-Yelagin/DataSource.git', :tag => s.version }
  s.source_files = 'DataSource/**/*.swift'
  s.dependency 'ReactiveCocoa', '~> 8.0'
end
