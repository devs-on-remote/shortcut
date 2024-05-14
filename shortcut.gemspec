# frozen_string_literal: true

require_relative 'lib/shortcut/version'

Gem::Specification.new do |spec|
  spec.name = 'shortcut'
  spec.version = Shortcut::VERSION
  spec.authors = ['Jan Piotrzkowski']

  spec.summary = 'Record, save & execute your most used scripts in the terminal'
  spec.description = 'A cli tool enhancing your terminal usage by allowing you to save your most used commands/scripts and then executing them in no time.'
  spec.homepage = 'https://github.com/devs-on-remote/shortcut'
  spec.license = 'BSD 2-Clause License'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/devs-on-remote/shortcut'
  spec.metadata['changelog_uri'] = 'https://github.com/devs-on-remote/shortcut/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.files += Dir['README.md', 'LICENSE.txt', 'lib/**/*', 'bin/*']

  spec.bindir = 'bin'
  spec.executables << 'shortcut' if File.exist?('bin/shortcut')
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency('rainbow')
  spec.add_dependency('thor')

  # Development dependencies
  spec.add_development_dependency('bundler')
  spec.add_development_dependency('rake')

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
