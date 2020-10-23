#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
require 'yaml'
pubspec = YAML.load_file(File.join('..', 'pubspec.yaml'))
libraryVersion = pubspec['version'].gsub('+', '-')

Pod::Spec.new do |s|
    s.name             = 'fluttercoreml'
    s.version          = '1.0.0'
    s.summary          = 'fluttercoreml'
    s.description      = <<-DESC
  A new flutter plugin project.
                         DESC
    s.homepage         = 'https://github.com/gongjiehong/fluttercoreml.git'
    s.license          = { :file => '../LICENSE' }
    s.author           = { 'gjh' => 'flutter-dev@googlegroups.com' }
    s.source           = { :path => '.' }
    s.source_files = 'Classes/**/*'
    s.public_header_files = 'Classes/**/*.h'
    s.dependency 'Flutter'
    
    s.ios.deployment_target = '13.0'
  end
  
  