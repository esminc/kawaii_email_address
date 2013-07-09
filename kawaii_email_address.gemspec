# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'email_format_validator/version'

Gem::Specification.new do |spec|
  spec.name          = "kawaii_email_address"
  spec.version       = KawaiiEmailAddress::VERSION
  spec.authors       = ["moro"]
  spec.email         = ["moronatural@gmail.com"]
  spec.description   = %q{Extraction of validate logic from `validates_email_format_of` to support docomo addresses}
  spec.summary       = %q{Extraction of validate logic from `validates_email_format_of` to support docomo addresses}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end