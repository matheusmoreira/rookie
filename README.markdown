# Rookie

Simple Rake tasks that make life easier.

# Installation

Latest version:

    gem install rookie

From source:

    git clone git://github.com/matheusmoreira/rookie.git

# Introduction

Putting this in your `Rakefile`:

    require 'rookie'

    Rookie::Tasks.new 'simple.gemspec'

Gets you a whole set of nice commands to work with your gem. Run `rake -T` for
details.
