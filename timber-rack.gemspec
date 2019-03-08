
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "timber-rack/version"

Gem::Specification.new do |spec|
  spec.name          = "timber-rack"
  spec.version       = Timber::Integrations::Rack::VERSION
  spec.authors       = ["Timber Technologies, Inc."]
  spec.email         = ["hi@timber.io"]

  spec.summary       = %q{Timber for Ruby is a drop in replacement for your Ruby logger that unobtrusively augments your logs with rich metadata and context making them easier to search, use, and read.}
  spec.homepage      = "https://docs.timber.io/languages/ruby/"
  spec.license       = "ISC"

  spec.required_ruby_version     = '>= 1.9.0'

  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/timberio/timber-ruby-rack"
    spec.metadata["changelog_uri"] = "https://github.com/timberio/timber-ruby-rack/blob/master/README.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # spec.add_dependency "timber", "3.0.0.alpha.0"
  spec.add_runtime_dependency "rack", ">= 1.2", "< 3.0"

  spec.add_development_dependency "bundler", ">= 0.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
