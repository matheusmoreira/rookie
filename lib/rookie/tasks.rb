require 'rookie/tasks/gem'
require 'rookie/tasks/git'
require 'rake/tasklib'

module Rookie
  class Tasks < ::Rake::TaskLib

    attr_accessor :gem, :git

    def initialize(gemspec = nil)
      self.gem = Tasks::Gem.new gemspec
      self.git = Tasks::Git.new gem.spec.version.to_s
      yield self if block_given?
      define
    end

    def define
      setup_tasks, clean_tasks, release_tasks = [], [], []

      if git
        release_tasks << 'git:release'
      end

      if gem
        setup_tasks << 'gem:setup'
        clean_tasks << 'gem:clean'
        release_tasks << 'gem:release'
      end

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
