Pod::Spec.new do |s|
  s.name         = "AFCalenderClient"
  s.version      = "0.0.1"
  s.summary      = "AFNetworking extension for downloading and parsing iCal calendars."
  s.homepage     = "https://github.com/jerolimov/AFCalenderClient"
  s.license      = 'MIT'

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'

  s.source       = { :git => "https://github.com/jerolimov/AFCalenderClient" }
  s.source_files = 'AFCalenderClient/*.{h,m}'

  s.requires_arc = true

  s.dependency 'AFNetworking', '~> 1.1.0'
end