# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "asana/gem_version"

Gem::Specification.new do |spec|
  spec.name          = "danger-asana"
  spec.version       = Asana::VERSION
  spec.authors       = ["Thomas Joulin"]
  spec.email         = ["thomas.joulin@gmail.com"]
  spec.description   = "A short description of danger-asana."
  spec.summary       = "A longer description of danger-asana."
  spec.homepage      = "https://github.com/thomasjoulin/danger-asana"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "asana", "~> 0.10"
  spec.add_runtime_dependency "danger-plugin-api", "~> 1.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "guard", "~> 2.14"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "listen", "3.0.7"
  spec.add_development_dependency "pry"
end
