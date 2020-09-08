# frozen_string_literal: true

require_relative 'lib/tesseract_ffi/version'

Gem::Specification.new do |spec|
  spec.name          = "tesseract_ffi"
  spec.version       = TesseractFFI::VERSION
  spec.authors       = ["David Verrier"]
  spec.email         = ["dverrier@gmail.com"]

  spec.summary       = %q{This is a Ruby-wrapper around the Tesseract C-API.}
  spec.description   = %q{This wrapper around the C-API allows use of the legacy modes of the recognition engine.}
  spec.homepage      = "https://github.com/dverrier/tesseract_ffi"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/dverrier/tesseract_ffi"
  spec.metadata["changelog_uri"] = "https://github.com/dverrier/tesseract_ffi"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.add_dependency "ffi"

  spec.add_development_dependency "minitest", "~> 5.14.1"
  spec.add_development_dependency "mocha", "~> 1.11.2"
  spec.add_development_dependency "simplecov", "~> 0.18.5"
  spec.add_development_dependency "awesome_print", "> 1.8.0"
  spec.add_development_dependency "nokogiri","> 1.10.10"

  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
