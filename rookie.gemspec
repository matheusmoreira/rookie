#!/usr/bin/env gem build
# encoding: utf-8

Gem::Specification.new 'rookie' do |gem|

  current_directory = File.dirname __FILE__
  version_file = File.expand_path "#{gem.name}.version", current_directory

  gem.version = File.read(version_file).chomp

  gem.summary = 'Simple Rake tasks that make life easier.'
  gem.homepage = 'https://github.com/matheusmoreira/rookie'
  gem.license = 'MPL-2.0'

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
