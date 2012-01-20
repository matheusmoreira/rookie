require 'fileutils'
require 'rake/tasklib'

module Rookie
  class Tasks < ::Rake::TaskLib
    class Gem < ::Rake::TaskLib

      attr_reader :spec, :dir

      def spec=(gemspec)
        @spec = case gemspec
          when ::Gem::Specification then gemspec
          when String then ::Gem::Specification.load gemspec if File.readable? gemspec
          else nil
        end
      end

      def dir=(dir)
        @dir = File.expand_path File.join(Dir.pwd, dir)
      end

      def initialize(gemspec = nil, gem_dir = 'gem')
        self.spec = gemspec
        self.dir = gem_dir
        yield self if block_given?
        define
      end

      def gem_file_name
        "#{spec.name}-#{spec.version}.gem"
      end

      def gem_file
        File.join dir, gem_file_name
      end

      def build_gem
        FileUtils.mkdir_p dir
        gem = ::Gem::Builder.new(spec).build
        FileUtils.mv gem, dir
      end

      def gem(cmd, arg = gem_file)
        "gem #{cmd} #{arg}"
      end

      def clean!
        FileUtils.rm_rf dir
      end

      def define
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
