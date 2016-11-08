# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "kingpin"
  spec.version       = '1.0'
  spec.authors       = ["jens.skott"]
  spec.email         = ["jens.skott@gmail.com"]
  spec.summary       = %q{Create and manage ecs resources}
  spec.description   = %q{Manage ecs trough aws api with commandline flags}
  spec.homepage      = "http://github.com/jensskott/kingpin"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($\)
  spec.require_paths = [lib]
  #spec.version       = Kingpin::VERSION
end
