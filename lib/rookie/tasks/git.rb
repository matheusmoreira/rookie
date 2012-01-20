require 'git'
require 'logger'
require 'rake/tasklib'

module Rookie
  class Tasks < ::Rake::TaskLib

    # This task provides a way to quickly and easily release git projects using
    # a gem specification.
    class Git < ::Rake::TaskLib

      # The version the project will be released under.
      attr_accessor :release_version

      # Directory which contains the git repository.
      attr_accessor :working_directory

      # Logger which will be used to log the git messages. Logs to SDTOUT by
      # default.
      attr_writer :logger

      # Lazily created logger.
      def logger
        @logger ||= create_logger
      end

      # Creates a new git task with the given parameters. Yields the instance
      # if given a block.
      #
      # Tasks do not get defined automatically; don't forget to call
      # #define_tasks!
      def initialize(release_version = nil, working_dir = Dir.pwd, logger = nil)
        self.logger = logger
        self.working_directory = working_dir
        self.release_version = release_version
        yield self if block_given?
      end

      # Computes a release tag for the given version.
      def release_tag(version = release_version)
        "v#{version}"
      end

      # Tags the latest commit in the repository with the given tag name.
      #
      # If the tag is invalid or already in the repository, an error will be
      # raised prior to tagging.
      def tag!(tag_name)
        raise "Tag '#{tag_name}' is invalid" if tag_name.nil? or tag_name.empty?
        if already_tagged? tag_name
          raise "Tag '#{tag_name}' already in repository"
        else
          git.add_tag tag_name
        end
      end

      # Pushes the changes in the given branch to the given remote repository.
      #
      # Tags will be pushed too if +tags+ is +true+.
      def push!(remote = 'origin', branch = 'master', tags = false)
        git.push remote, branch, tags
      end

      # Tags the latest commit with the given version tag and pushes the given
      # branch to the given remote repository, including tags.
      def release!(version_tag = release_tag, remote = 'origin', branch = 'master')
        tag! version_tag
        push! remote, branch, true
      end

      # Returns whether the repository already contains the given tag name.
      def already_tagged?(tag_name)
        git.tag tag_name
      rescue ::Git::GitTagNameDoesNotExist
        false
      end

      # Defines the git tasks.
      def define_tasks!
        namespace :git do
          desc 'Tags latest commit with the given tag name'
          task :tag, :tag_name do |task, args|
            tag! args[:tag_name]
          end

          desc 'Pushes changes to a remote repository'
          task :push, :remote, :branch do |task, args|
            args.with_defaults remote: 'origin', branch: 'master'
            push! args[:remote], args[:branch]
          end

          namespace :push do
            desc 'Pushes tags to a remote repository'
            task :tags, :remote, :branch do |task, args|
              args.with_defaults remote: 'origin', branch: 'master'
              push! args[:remote], args[:branch]
            end
          end

          desc 'Release current version'
          task :release, :version, :remote, :branch do |task, args|
            args.with_defaults version: release_tag, remote: 'origin', branch: 'master'
            release! args[:version], args[:remote], args[:branch]
          end
        end
      end

      protected

      # Lazily created git handle. Uses the logger returned by #logger.
      def git
        @git ||= ::Git.open working_directory, :log => logger
      end

      # Creates a logger to STDOUT at INFO level with a custom formatter.
      def create_logger
        ::Logger.new(STDOUT).tap do |logger|
          logger.level = ::Logger::INFO
          logger.formatter = proc { |severity, datetime, progname, msg| "#{msg}\n" }
        end
      end

    end

  end
end
