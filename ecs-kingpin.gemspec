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

  spec.files         = `git ls-files`.split($\)
  spec.executables   = ["ecs-kingpin"]
  spec.require_paths = [lib]
  spec.version       = '0.1.0'
end
