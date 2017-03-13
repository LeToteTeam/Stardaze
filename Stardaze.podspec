#
#  Be sure to run `pod spec lint Stardaze.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "Stardaze"
  s.version      = "0.0.3"
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
