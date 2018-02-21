Pod::Spec.new do |s|
  s.name         = "Stardaze"
  s.version      = "1.3.1"
  s.summary      = "A GraphQL query builder"
  s.description  = "Stardaze is a type safe query builder modeled closely from the GraphQL specification."
  s.license      = "MIT"
  s.authors      = { "william wilson" => "will@letote.com" }
  s.homepage     = "https://github.com/LeToteTeam/Stardaze"

  s.platform     = :ios
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/LeToteTeam/Stardaze.git", :tag => "#{s.version}" }
  s.source_files  = "Stardaze/*.swift"
end
