# frozen_string_literal: true

require_relative "lib/pretty_logger/version"

Gem::Specification.new do |spec|
  spec.name = "pretty_logger"
  spec.version = PrettyLogger::VERSION
  spec.authors = ["Rocco Nicholls"]
  spec.email = ["rocco11nicholls@gmail.com"]

  spec.summary = "Quick logger that lets you output to a different log file for more controlled breakdowns of site visits."
  spec.description = "Quick logger that lets you output to a different log file for more controlled breakdowns of site visits"
  spec.homepage = "https://github.com/Rockster160/pretty_logger"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Rockster160/pretty_logger"
  spec.metadata["changelog_uri"] = "https://github.com/Rockster160/pretty_logger/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{\A(?:bin/|test/|spec/|features/|\.git|\.circleci/|appveyor\.yml)})
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "coderay", "~> 1.1.3"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
