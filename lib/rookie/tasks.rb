require 'rookie/tasks/gem'
require 'rake/tasklib'

module Rookie
  class Tasks < ::Rake::TaskLib

    attr_accessor :gem

    def initialize(gemspec = nil)
      self.gem = Tasks::Gem.new gemspec
      yield self if block_given?
      define
    end

    def define
      setup_tasks = []
      clean_tasks = []
      if gem then setup_tasks << 'gem:setup'; clean_tasks << 'gem:clean' end

      desc 'Setup project'
      task :setup => setup_tasks

      desc 'Remove temporary files'
      task :clean => clean_tasks

      task :default => :setup
    end

  end
end
