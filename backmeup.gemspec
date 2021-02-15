# frozen_string_literal: true

require_relative 'lib/backmeup/version'

Gem::Specification.new do |spec|
  spec.name          = 'backmeup'
  spec.version       = Backmeup::VERSION
  spec.authors       = ['thomasregnet']
  # spec.email         = ['TODO: Write your email address']

  spec.summary       = 'Handle backups.'
  spec.description   = 'Create and purge backups'
  spec.homepage      = 'https://github.com/thomasregnet/backmeup'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/thomasregnet/backmeup'
  # spec.metadata['changelog_uri'] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'expire', '~> 0.2.0'
  spec.add_dependency 'thor'
  spec.add_dependency 'tty-command', '~> 0.9'
  spec.add_dependency 'tty-file'
  spec.add_dependency 'zeitwerk'

  spec.add_development_dependency 'aruba'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'reek'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'simplecov'
end
