# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wowaudit/version'

Gem::Specification.new do |spec|
  spec.name          = "wowaudit"
  spec.version       = Wowaudit::VERSION
  spec.authors       = ["Emiel van Lankveld"]
  spec.email         = ["emiel@vanlankveld.me"]
  spec.summary       = %q{World of Warcraft data retrieval for characters from Blizzard's API.}
  spec.description   = %q{Opiniated World of Warcraft data retrieval for characters from Blizzard's API.}
  spec.homepage      = "https://github.com/Sheday/wowaudit"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '~> 2.2'
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "byebug"

  spec.add_runtime_dependency "rbattlenet"
  spec.add_runtime_dependency "typhoeus", "~> 1.1"
  spec.add_runtime_dependency "require_all" # convenience
end
