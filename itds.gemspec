# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'itds/version'

Gem::Specification.new do |spec|
  spec.name          = "itds"
  spec.version       = Itds::VERSION
  spec.authors       = ["Andrew Liu"]
  spec.email         = ["liusandrew@gmail.com"]
  spec.summary       = %q{A very simple SQL server client.}
  spec.homepage      = "http://github.com/andl/itds"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "tiny_tds", "~> 0.6.2"
  spec.add_dependency "terminal-table", "~> 1.4.5"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
