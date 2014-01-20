# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tupplur/version'

Gem::Specification.new do |spec|
  spec.name          = "tupplur"
  spec.version       = Tupplur::VERSION
  spec.authors       = ["Robin Edman"]
  spec.email         = ["robin.edman@gmail.com"]
  spec.description   = %q{Tupplur extends Mongoid, allowing fields to be exposed as readable or writable from outside of your application.}
  spec.summary       = spec.description
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "turn", "~> 0.9"
  spec.add_development_dependency "activesupport", "~> 3.0"
  spec.add_development_dependency "rack-test", "~> 0.6.2"
  spec.add_development_dependency "virtus", "~> 1.0"
  spec.add_development_dependency "mongoid", "~> 3.0"

  spec.add_runtime_dependency "cuba", "~>3.1.0"
  # Mongoid is an implicitly assumed dependency.

  # We don't specify a version since we don't want to risk conflicts with
  # Mongoid.
  spec.add_runtime_dependency "activesupport"
end
