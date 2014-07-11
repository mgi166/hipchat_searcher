# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hipchat_searcher/version'

Gem::Specification.new do |spec|
  spec.name          = "hipchat_searcher"
  spec.version       = HipchatSearcher::VERSION
  spec.authors       = ["mgi166"]
  spec.email         = ["skskoari@gmail.com"]
  spec.summary       = %q{Search hipchat log on terminal}
  spec.homepage      = "https://github.com/mgi166/hipchat_searcher"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "hipchat"
  spec.add_dependency "colorize"
  spec.add_dependency "hashie"
  spec.add_dependency "slop"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "coveralls"
end
