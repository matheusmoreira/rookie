# Rookie

Simple Rake tasks that make life easier.

Putting this in your `Rakefile`:

    require 'rookie'

    Rookie::Tasks.new 'simple.gemspec'

Gets you a whole set of nice commands to work with your gem. Run `rake -T` for
details.
