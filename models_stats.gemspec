# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'models_stats/version'

Gem::Specification.new do |spec|
  spec.name          = "models_stats"
  spec.version       = ModelsStats::VERSION
  spec.authors       = ["Andrey Morskov"]
  spec.email         = ["accessd0@gmail.com"]
  spec.summary       = %q{Statistics for rails models}
  spec.description   = %q{Graphics for rails models with MetricsGraphics.js}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 3.0"
  spec.add_dependency "redis-rails"
  spec.add_dependency "redis-objects"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
