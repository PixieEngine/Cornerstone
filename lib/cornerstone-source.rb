require "cornerstone-source/version"

module Cornerstone
  module Source
    if defined? ::Rails::Engine
      class Rails < Rails::Engine
      end
    elsif defined? ::Sprockets
      root_dir = File.expand_path(File.dirname(File.dirname(__FILE__)))

      ::Sprockets.append_path File.join(root_dir, "source")
    end
  end
end
