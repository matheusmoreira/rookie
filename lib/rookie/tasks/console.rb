require 'rake/tasklib'

module Rookie
  class Tasks < ::Rake::TaskLib

    # This task provides an easy way to interactively test your gem by
    # automatically loading and requiring it in an interactive ruby session.
    class Console < ::Rake::TaskLib

      # The gem specification.
      attr_accessor :spec

      # The name of the program to invoke.
      attr_accessor :program

      # The full command to execute.
      attr_writer :command

      # Unless set explicitly, will be automatically generated from the #program
      # name and gem specification.
      def command
        @command ||= generate_command_string
      end

      # Creates a new console task with the given parameters. Options may
      # specify:
      #
      # [:program]  the name of the program to invoke; +irb+ by default.
      # [:command]  the full command to execute. Use if the command you want to
      #             run doesn't take the <tt>-I</tt> and <tt>-r</tt> command
      #             line arguments.
      #
      # Yields the instance if given a block.
      #
      # Tasks do not get defined automatically; don't forget to call
      # #define_tasks!
      def initialize(spec, opts = {})
        self.spec = spec
        self.program = opts.fetch :program, :irb
        self.command = opts.fetch :command, nil
        yield self if block_given?
      end

      # Defines the console task.
      def define_tasks!
        desc 'Starts an interactive ruby session with the gem loaded'
        task :console do
          sh command
        end
      end

      # Generates a command string from this task's #program name and gem
      # specification. For example:
      #
      #   irb -I lib -r gem_name
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
