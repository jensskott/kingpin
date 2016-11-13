# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'bundler'
require 'rake'

Gem::Specification.new do |spec|
  spec.name          = "ecs-kingpin"
  spec.authors       = ["jens.skott"]
  spec.email         = ["jens.skott@gmail.com"]
  spec.summary       = %q{Create and manage ecs resources}
  spec.description   = %q{Manage ecs trough aws api with commandline flags}
  spec.homepage      = "http://github.com/jensskott/kingpin"
  spec.license       = "MIT"
  # Gem deps
  spec.add_runtime_dependency 'aws-sdk', '>= 2.6.2'
  spec.add_runtime_dependency 'trollop', '2.1.2'
  spec.add_runtime_dependency 'hashie', '3.4.6'
  spec.add_runtime_dependency 'json-compare', '0.1.8'
  spec.add_runtime_dependency 'yajl-ruby', '1.3.0'
  spec.add_runtime_dependency 'deep_merge', '1.1.1'

  spec.files         = `git ls-files`.split($\)
  spec.executables   = ["ecs-kingpin"]
  spec.require_paths = [lib]
  spec.version       = '0.1.4'
end
