# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kaseyaws/version'

Gem::Specification.new do |s|
  s.name          = "kaseyaws"
  s.version       = KaseyaWS::VERSION
  s.authors       = "Phillip Henslee"
  s.email         = "phenslee@towerdigital.us"
  s.description   = "A Ruby Gem for Kaseya's VSA web service"
  s.summary       = "A simple client for the Kaseya VSA web service"
  s.homepage      = "https://github.com/towerdigital/kaseyaws"
  s.license       = "MIT"

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|s|features)/})
  s.require_paths = ["lib"]
  s.add_dependency("savon", [">= 2.1.0"])
  s.add_dependency("json")

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"
end
