# Utilities to create and work with Ruby gems.
#
# @author Matheus Afonso Martins Moreira
module Rookie
end

class << Rookie

  # Location of the Rookie gem.
  #
  # @return [String] the absolute path to the Rookie gem
  # @since 0.4.0
  def root
    File.expand_path '..', File.dirname(__FILE__)
  end

end

require 'rookie/tasks'
require 'rookie/version'
