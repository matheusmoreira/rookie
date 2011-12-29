require 'git'
require 'logger'
require 'rake/tasklib'

module Rookie
  class Tasks < ::Rake::TaskLib
    class Git < ::Rake::TaskLib

      attr_accessor :release_version

      def initialize(release_version = nil, working_dir = Dir.pwd)
        logger = ::Logger.new STDOUT
        logger.level = ::Logger::INFO
        self.git = ::Git.open working_dir, :log => logger
        self.release_version = release_version
        yield self if block_given?
        define
      end

      def release_tag(version = release_version)
        "v#{version.to_s}"
      end

      def tag!(tag_name)
        raise "Tag '#{tag_name.inspect}' is invalid" if tag_name.nil? or tag_name.empty?
        if already_tagged? tag_name
          raise "Tag '#{tag_name}' already in repository"
        else
          git.add_tag tag_name
        end
      end

      def push!(remote = 'origin', branch = 'master', tags = false)
        git.push remote, branch, tags
      end

      def release!(version_tag = release_tag, remote = 'origin', branch = 'master')
        tag! version_tag
        push! remote, branch, true
      end

      def already_tagged?(tag_name)
        git.tag tag_name rescue nil
      end

      def define
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

      def git=(repo)
        @git = repo
      end

      def git
        @git
      end

    end
  end
end
