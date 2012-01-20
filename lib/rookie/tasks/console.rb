require 'rake/tasklib'

module Rookie
  class Tasks < ::Rake::TaskLib
    class Console < ::Rake::TaskLib

      attr_accessor :spec, :program
      attr_writer :command

      def command
        @command ||= generate_command_string
      end

      def initialize(spec, opts = {})
        self.spec = spec
        self.program = opts.fetch :program, 'irb'
        self.command = opts.fetch :command, nil
        yield self if block_given?
        define
      end

      def define
        desc 'Starts an interactive ruby session with your gem loaded'
        task :console do
          sh command
        end
      end

      def generate_command_string
        program.to_s.dup.tap do |command_string|
          spec.require_paths.each do |path|
            command_string << ' -I ' << path
          end
          command_string << ' -r ' << spec.name
        end
      end

    end
  end
end
