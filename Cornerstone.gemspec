# -*- encoding: utf-8 -*-
require File.expand_path('../lib/Cornerstone/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Matt Diebolt", "Daniel X. Moore"]
  gem.email         = ["pixie@pixieengine.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = "https://github.com/PixieEngine/Cornerstone"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "Cornerstone"
  gem.require_paths = ["lib"]
  gem.version       = Cornerstone::VERSION

  gem.add_dependency "middleman", "~>3.0.0.beta.3"
  gem.add_development_dependency "rb-inotify"
  gem.add_development_dependency "therubyracer"
end
