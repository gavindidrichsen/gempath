# frozen_string_literal: true

require_relative 'lib/gempath/version'

Gem::Specification.new do |spec|
  spec.name          = 'gempath'
  spec.version       = Gempath::VERSION
  spec.authors       = ['Gavin Didrichsen']
  spec.email         = ['gavin.didrichsen@gmail.com']

  spec.summary       = 'Analyze gem dependencies and their relationships'
  spec.description   = 'A tool for analyzing gem dependencies, showing dependency paths,' \
                        'versions, and relationships between gems in a Gemfile.lock'
  spec.homepage      = 'https://github.com/gavindidrichsen/gempath'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.5.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.glob('{bin,lib}/**/*') + %w[LICENSE.txt README.md CHANGELOG.md]
  spec.files.reject! { |f| File.directory?(f) }
  spec.bindir        = 'bin'
  spec.executables   = ['gempath']
  spec.require_paths = ['lib']

  spec.add_dependency 'bundler', '~> 2.0'
  spec.add_dependency 'thor', '~> 1.0' # For CLI interface

  spec.metadata['rubygems_mfa_required'] = 'true'
end
