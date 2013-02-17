# -*- encoding: utf-8 -*-
require File.expand_path('../lib/cornerstone-source/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "cornerstone-source"
  gem.version       = Cornerstone::Source::VERSION
  gem.authors       = ["Matt Diebolt", "Daniel X. Moore"]
  gem.email         = ["pixie@pixieengine.com"]
  gem.homepage      = "https://github.com/PixieEngine/Cornerstone"
  gem.summary       = %q{A solid foundation for JavaScript}
  gem.description   = %q{Cornerstone provides a solid foundation for working with JavaScript. It aggressively shivs many of the core classes.}

  gem.files         = `git ls-files`.split("\n")
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rake"

  gem.add_dependency "sprockets"
end
