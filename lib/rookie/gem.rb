require 'jewel'

module Rookie

  # Information about the Rookie gem.
  #
  # @author Matheus Afonso Martins Moreira
  # @since 0.4.0
  class Gem < Jewel::Gem

    root '../..'

    specification ::Gem::Specification.load(root.join 'rookie.gemspec')

  end

end
