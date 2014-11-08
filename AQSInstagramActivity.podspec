Pod::Spec.new do |s|
  s.name         = "AQSInstagramActivity"
  s.version      = "0.1.0"
  s.summary      = "[iOS] UIActivity Class for Instagram"
  s.homepage     = "https://github.com/AquaSupport/AQSInstagramActivity"
  s.license      = "MIT"
  s.author       = { "kaiinui" => "lied.der.optik@gmail.com" }
  s.source       = { :git => "https://github.com/AquaSupport/AQSInstagramActivity.git", :tag => "v0.1.0" }
  s.source_files  = "AQSInstagramActivity/Classes/**/*.{h,m}"
  s.resources = ["AQSInstagramActivity/Classes/**/*.png"]
  s.requires_arc = true
  s.platform = "ios", '7.0'
end