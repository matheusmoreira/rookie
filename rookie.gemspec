#!/usr/bin/env gem build
# encoding: utf-8
$:.unshift File.expand_path('../lib', __FILE__)

require 'rookie/version'

Gem::Specification.new 'rookie' do |gem|

  gem.version     = Rookie::Version::STRING
  gem.summary     = 'Simple Rake tasks that make life easier.'
  gem.description = gem.summary
  gem.homepage    = 'https://github.com/matheusmoreira/rookie'
  gem.license     = 'Mozilla Public License, version 2.0'

  gem.author = 'Matheus Afonso Martins Moreira'
  gem.email  = 'matheus.a.m.moreira@gmail.com'

  gem.files = `git ls-files`.split "\n"

  gem.add_runtime_dependency 'git'
  gem.add_runtime_dependency 'rake'

  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'redcarpet' # yard uses it for markdown formatting

end
