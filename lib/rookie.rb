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

  # The gem directory, relative to the root.
  #
  # @return [String] the absolute path to the gem directory
  # @since 0.4.0
  def gem
    File.join root, 'gem'
  end

  # The licenses directory, relative to the gem directory.
  #
  # @return [String] the absolute path to the licenses directory
  # @since 0.4.0
  def licenses
    File.join gem, 'licenses'
  end

  # The template directory, relative to the gem directory.
  #
  # @return [String] the absolute path to the template directory
  # @since 0.4.0
  def template
    File.join gem, 'template'
  end

end

require 'rookie/tasks'
require 'rookie/version'
