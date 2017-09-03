Pod::Spec.new do |s|

  s.name         = "Debugger"
  s.version      = "0.0.1"
  s.summary      = "An in-app debugging tool for iOS."

  s.description  = <<-DESC
An in-app debugging tool for iOS
                   DESC

  s.homepage     = "https://github.com/Joe0708/Debugger"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author            = { "Joe" => "joesir7@foxmail.com" }

  s.platform     = :ios, "9.0"

  s.ios.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/Joe0708/Debugger.git", :tag => "#{s.version}" }

  s.source_files  = "DebuggerExample/Debugger/Classes/**/*"
  s.resources = "DebuggerExample/Debugger/Assets/*.png"

  s.frameworks = "UIKit", "Foundation"
  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency "SandboxBrowser"
  s.dependency "SpreadsheetView"
end
