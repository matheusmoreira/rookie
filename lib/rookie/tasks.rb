require 'rookie/tasks/console'
require 'rookie/tasks/gem'
require 'rookie/tasks/git'
require 'rake/tasklib'

module Rookie

  # Provides many useful tasks, like the Gem, Git and Console tasks.
  #
  # Don't forget to call #define_tasks! after creating an instance of this
  # class!
  class Tasks < ::Rake::TaskLib

    # The Gem task.
    attr_accessor :gem

    # The Git task.
    attr_accessor :git

    # The Console task.
    attr_accessor :console

    # Initializes the tasks with the given gem specification and options.
    #
    # Yields the new instance if given a block.
    def initialize(gemspec, opts = {})
      self.gem = Tasks::Gem.new gemspec
      self.git = Tasks::Git.new gem.spec.version.to_s
      self.console = Tasks::Console.new gem.spec, opts
      yield self if block_given?
    end

    # Defines the tasks for all initialized (not +nil+) tasks.
    def define_tasks!
      setup_tasks, clean_tasks, release_tasks = [], [], []

      if git
        git.define_tasks!
        release_tasks << 'git:release'
      end

      if gem
        gem.define_tasks!
        setup_tasks << 'gem:setup'
        clean_tasks << 'gem:clean'
        release_tasks << 'gem:release'
      end

      console.define_tasks! if console

      desc 'Setup project'
      task :setup => setup_tasks

      desc 'Remove temporary files'
      task :clean => clean_tasks

      desc 'Release project'
      task :release => release_tasks + clean_tasks

      task :default => :setup
    end

  end

end
