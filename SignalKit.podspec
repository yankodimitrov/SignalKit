Pod::Spec.new do |s|

  s.name         = "SignalKit"
  s.version      = "4.0.0"
  s.summary      = "SignalKit is a type safe event and binding Swift framework"

  s.description  = <<-DESC
                   SignalKit is a type safe event and binding Swift framework with great focus on clean and readable API
                   DESC

  s.homepage     = "https://github.com/yankodimitrov/SignalKit"
  s.license      = { :type => "MIT", :file => "LICENSE.txt" }
  s.author       = { "Yanko Dimitrov" => "https://twitter.com/_yankodimitrov" }
  s.social_media_url   = "https://twitter.com/_yankodimitrov"

  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"

  s.source       = { :git => "https://github.com/yankodimitrov/SignalKit.git", :tag => "v#{s.version}" }
  s.source_files  = ["SignalKit", "SignalKit/Protocols", "SignalKit/Utilities", "SignalKit/Extensions", "SignalKit/Extensions/UIKit"]
  
  s.requires_arc = true

end
