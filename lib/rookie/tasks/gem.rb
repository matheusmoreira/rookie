require 'fileutils'
require 'rake/tasklib'

module Rookie
  class Tasks < ::Rake::TaskLib

    # Adds various gem management tasks that allows you to build, install,
    # uninstall and release your gem with ease.
    class Gem < ::Rake::TaskLib

      # The gem specification.
      attr_reader :spec

      # The directory where <tt>.gem</tt> files will be stored. <tt>'gem'</tt>
      # by default.
      #
      # This directory will be completely erased by the +clean+ task. Make sure
      # it is not in use!
      attr_reader :dir

      # Sets this task's gem specification. Loads it from a file if given a
      # string.
      def spec=(gemspec)
        @spec = case gemspec
          when ::Gem::Specification then gemspec
          when String then ::Gem::Specification.load gemspec
          else nil
        end
      end

      # The directory where packaged gems will be stored. Always relative to the
      # current directory.
      #
      # This directory will be completely erased by the +clean+ task. Make sure
      # it is not in use!
      def dir=(dir)
        @dir = File.expand_path File.join(Dir.pwd, dir)
      end

      # Creates a new gem task with the given gem specification and temporary
      # gem directory.
      #
      # Tasks do not get defined automatically; don't forget to call
      # #define_tasks!
      def initialize(gemspec = nil, gem_dir = 'gem')
        self.spec = gemspec
        self.dir = gem_dir
        yield self if block_given?
      end

      # The name of the packaged gem file.
      def gem_file_name
        "#{spec.name}-#{spec.version}.gem"
      end

      # The full path to the gem file.
      def gem_file
        File.join dir, gem_file_name
      end

      # Builds the gem from the specification and moves it to the gem directory.
      def build_gem
        FileUtils.mkdir_p dir

        if RUBY_VERSION >= '2.0.0'
          require 'rubygems/package'
          gem = ::Gem::Package.build(spec)
        else
          gem = ::Gem::Builder.new(spec).build
        end

        FileUtils.mv gem, dir
      end

      # Executes a gem command.
      def gem(cmd, arg = gem_file)
        "gem #{cmd} #{arg}"
      end

      # Removes the gem directory.
      def clean!
        FileUtils.rm_rf dir
      end

      # Defines the gem tasks.
      def define_tasks!
        directory dir

        namespace :gem do
          desc 'Builds the gem from the specification'
          task :build => dir do
            build_gem
          end

          desc 'Pushes the gem to rubygems.org'
          task :push => :build do
            sh gem :push
          end

          desc 'Same as gem:push'
          task :release => :push

          desc 'Installs the gem locally'
          task :install => :build do
            sh gem :install
          end

          desc 'Uninstalls the gem'
          task :uninstall do
            sh gem(:uninstall, spec.name)
          end

          desc 'Removes the gem package directory'
          task :clean do
            clean!
          end

          desc 'Installs the gem locally and cleans up'
          task :setup => [ :install, :clean ]
        end

        desc 'Same as gem:build'
        task :gem => 'gem:build'
      end

    end

  end
end
