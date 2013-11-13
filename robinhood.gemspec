# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'robinhood/version'

Gem::Specification.new do |spec|
  spec.name          = "robinhood"
  spec.version       = Robinhood::VERSION
  spec.authors       = ["Josep Jaume"]
  spec.email         = ["josepjaume@gmail.com"]
  spec.description   = %q{Robin hood leverages celluloid actors and redis-mutex to distribute long-lived, single-instance processes across multiple servers.}
  spec.summary       = spec.description
  spec.homepage      = "http://www.codegram.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'celluloid'
  spec.add_dependency 'redis-mutex'
  spec.add_dependency 'daemons'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-nav"
end
