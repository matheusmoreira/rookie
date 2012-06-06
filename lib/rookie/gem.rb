require 'jewel'

module Rookie

  # Information about the Rookie gem.
  #
  # @author Matheus Afonso Martins Moreira
  # @since 0.4.0
  class Gem < Jewel::Gem

    name! :rookie
    version '0.4.0'
    summary 'Simple Rake tasks that make life easier.'
    homepage 'https://github.com/matheusmoreira/rookie'
    license 'Mozilla Public License, version 2.0'

    author 'Matheus Afonso Martins Moreira'
    email 'matheus.a.m.moreira@gmail.com'

    files `git ls-files`.split "\n"
    root '../..'

    depend_on :git
    depend_on :jewel
    depend_on :rake

    development do
      depend_on :bundler
      depend_on :redcarpet
      depend_on :yard
    end

  end

end
