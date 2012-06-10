require 'jewel'

module Rookie

  # Information about the Rookie gem.
  #
  # @author Matheus Afonso Martins Moreira
  # @since 0.4.0
  class Gem < Jewel::Gem

    root '../..'

    gemspec_path = root.join('rookie.gemspec').to_s
    specification ::Gem::Specification.load gemspec_path

  end

end
