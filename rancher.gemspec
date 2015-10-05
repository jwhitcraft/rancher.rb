# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rancher/version'

Gem::Specification.new do |spec|
  spec.name          = 'rancher.rb'
  spec.version       = Rancher::VERSION.dup
  spec.authors       = ['Jon Whitcraft']
  spec.email         = ['jwhitcraft@mac.com']
  spec.summary       = %q{Ruby API Client for Rancher}
  spec.description   = %q{Consume the API from Rancher with Ruby!}
  spec.homepage      = 'https://github.com/jwhitcraft/rancher.rb'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_dependency 'sawyer', '>= 0.5.3', '~> 0.6.0'
end
