# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mymoviesdb/version'

Gem::Specification.new do |spec|
  spec.name          = "mymoviesdb"
  spec.version       = MyMoviesDB::VERSION
  spec.authors       = ["Oleksandr Ulizko"]
  spec.email         = ["shurikovich@bigmir.net"]

  spec.summary       = %q{Your home movies database}
  spec.homepage      = "https://github.com/ulizko/mymoviesdb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = "mymoviesdb"
  spec.require_paths = ["lib"]

  spec.add_dependency 'nokogiri'
  spec.add_dependency 'slop', '~> 4.3'
  spec.add_dependency 'ruby-progressbar'
  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubygems-tasks'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'yard'
end
