# Utilities to create and work with Ruby gems.
module Rookie
end

class << Rookie

  # Location of the Rookie gem.
  def root
    File.expand_path '..', File.dirname(__FILE__)
  end

end

require 'rookie/tasks'
require 'rookie/version'
