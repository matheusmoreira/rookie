#!/usr/bin/env gem build
# encoding: utf-8

Gem::Specification.new 'rookie' do |gem|

  gem.version = File.read('rookie.version').chomp

  gem.summary = 'Simple Rake tasks that make life easier.'
  gem.homepage = 'https://github.com/matheusmoreira/rookie'
  gem.license = 'Mozilla Public License, version 2.0'

  gem.author = 'Matheus Afonso Martins Moreira'
  gem.email = 'matheus.a.m.moreira@gmail.com'

  gem.files = `git ls-files`.split "\n"

  gem.add_runtime_dependency 'git'
  gem.add_runtime_dependency 'jewel'
  gem.add_runtime_dependency 'rake'

  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'redcarpet' # used by yard for markdown formatting
  gem.add_development_dependency 'yard'

end
