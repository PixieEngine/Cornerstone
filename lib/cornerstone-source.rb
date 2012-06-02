require "cornerstone-source/version"

# Sneaky require for Rails engine environment
if defined? ::Rails::Engine
  require "cornerstone-source/rails"
elsif defined? ::Sprockets
  require "cornerstone-source/sprockets"
end

module Cornerstone
  module Source
  end
end
