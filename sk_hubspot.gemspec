# frozen_string_literal: true

require_relative "lib/skiwo/hubspot/version"

Gem::Specification.new do |spec|
  spec.name = "sk_hubspot"
  spec.version = Skiwo::Hubspot::VERSION
  spec.authors = ["Kjetil Brevik"]
  spec.email = ["kjetil@skiwo.com"]

  spec.summary = "Api client for Hubspot"
  spec.description = "This gem is just a thin wrapper around the hubspot-api-client"
  spec.homepage = "https://github.com/Skiwo/sk_hubspot"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.4"

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "activesupport", ">= 6.0"
  spec.add_dependency "hubspot-api-client", "~> 17.2"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
