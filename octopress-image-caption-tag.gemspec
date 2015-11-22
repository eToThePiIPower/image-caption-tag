# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'octopress-image-caption-tag/version'

Gem::Specification.new do |spec|
  spec.name          = 'octopress-image-caption-tag'
  spec.version       = Octopress::Tags::ImageCaptionTag::VERSION
  spec.authors       = ['Charles Beynon']
  spec.email         = ['eToThePiIPower@gmail.com']
  spec.summary       = 'A tag to create images with pretty captions for Jekyll and Octopress blogs.'
  spec.description   = 'A tag to create images with pretty captions for Jekyll and Octopress blogs.'
  spec.homepage      = 'https://github.com/eToThePiIPower/octopress-image-caption-tag'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split("\n").grep(%r{^(bin\/|lib\/|assets\/|changelog|readme|license)}i)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'jekyll'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'clash'
  spec.add_development_dependency 'rubocop'

  spec.add_development_dependency 'pry-byebug' if RUBY_VERSION >= '2'
end
