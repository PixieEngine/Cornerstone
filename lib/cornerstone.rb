require "cornerstone/version"

# Sneaky require for Rails engine environment
if defined? ::Rails::Engine
  require "cornerstone/rails"
elsif defined? ::Sprockets
  require "cornerstone/sprockets"
end

module Cornerstone
end
