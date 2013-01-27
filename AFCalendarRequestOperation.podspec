Pod::Spec.new do |s|
  s.name         = "AFCalendarRequestOperation"
  s.version      = "0.2.0"
  s.summary      = "AFNetworking extension for downloading and parsing calendars."
  s.homepage     = "https://github.com/jerolimov/AFCalendarRequestOperation"
  s.license      = 'MIT'

  s.source       = { :git => "https://github.com/jerolimov/AFCalendarRequestOperation" }
  s.source_files = "AFCalendarRequestOperation/*.{h,m}"

  s.requires_arc = true

  s.framework    = "EventKit"

  s.dependency     "AFNetworking", "~> 1.1.0"
end
