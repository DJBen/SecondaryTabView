#
# Be sure to run `pod lib lint SecondaryTabView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SecondaryTabView'
  s.version          = '1.0'
  s.summary          = 'A secondary tab navigation view that appears on the top of the screen, right below the primary navigation bar.'

  s.homepage         = 'https://github.com/DJBen'
  s.license          = { :type => 'MIT' }
  s.author           = { 'Sihao Lu' => 'lsh32768@gmail.com' }
  s.source           = { :git => 'https://github.com/DJBen/SecondaryTabView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'

  s.swift_version = ['5.5']
  s.source_files = 'Sources/**/*.swift'
end
