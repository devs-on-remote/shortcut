require 'pty'
require 'expect'
require 'rainbow'
require 'fileutils'
require 'timeout'

module Shortcut
  module Commands
    module Record
      READ_SIZE = 1024
      WHITELISTED_COMMANDS = %w[
        echo
        date
        cal
        df
        top
        who
        uptime
        ls
        ifconfig
        ps
        diskutil
        system_profiler
        pwd
        env
        history
        groups
        id
        hostname
        uname
        w
        last
        du
        netstat
        printenv
      ]

      # ------------------------------------------------------------------------
      def self.call
        Dir.chdir('/Users') do
          PTY.spawn('bash --login') do |reader, writer, pid|
            res = record_commands(reader, writer)
            save_commands(res[:commands], res[:current_path])
            clean(pid)
          end
        end
      rescue PTY::ChildExited
        puts('The child process exited!')
      end

      # ------------------------------------------------------------------------
      ## Record commands from the user
      def self.record_commands(reader, writer)
        commands = []
        current_path = ''
        loop do
          # Output the result of the command
          begin
            Timeout.timeout(2) do
              reader.expect(/[$#] /) do |output|
                print_result(output) if commands.last&.split&.any? { |word| WHITELISTED_COMMANDS.include?(word) }
              end
            end
          rescue Timeout::Error
            # Send SIGINT to the long lasting command to stop it
            writer.puts("\x03")
            flush_reader(reader)
          end

          print_command_history(commands)

          # Get current path with a prompt
          writer.puts('pwd')

          sleep 0.1

          output = reader.readpartial(READ_SIZE)
          pwd_output = output.split("\n").find { |line| line.include? '/Users' }
          current_path = pwd_output.strip unless pwd_output.nil?

          # Print the current path
          print_current_path(current_path)

          input = STDIN.gets.chomp
          break if input == 'sc-stop'

          if input == 'sc-undo'
            commands.pop
            writer.puts('')
            next
          end

          writer.puts(input)
          commands << input
        end

        { commands:, current_path: }
      end

      # ------------------------------------------------------------------------
      ## Flush the reader
      def self.flush_reader(reader)
        while true
          reader.read_nonblock(1024) # Read and discard output
        end
      rescue IO::WaitReadable, EOFError
      end

      # ------------------------------------------------------------------------
      ## Print the saved command history
      def self.print_command_history(commands)
        command_list = commands.map { |command| command + ' > ' }
                               .join

        puts(Rainbow('[Shortcut History]: ').yellow + command_list)
      end

      # ------------------------------------------------------------------------
      ## Print the result of the command
      def self.print_result(output)
        return unless output

        puts(output[0].split("\n")[1..-2]) unless output[0].nil?
      end

      # ------------------------------------------------------------------------
      ## Print the current path
      def self.print_current_path(current_path)
        prompt = "➜ #{current_path.strip} ~ "
        print(Rainbow(prompt).aqua)

        # Ensure cursor starts right after the prompt
        $stdout.flush
      end

      # ------------------------------------------------------------------------
      # Save captured commands to a script file in /tmp/scripts directory
      def self.save_commands(commands, current_path)
        script_name = ''
        loop do
          Helpers::Messages.ask_for_script_name

          script_name = STDIN.gets.chomp

          if script_name.empty?
            Helpers::Messages.name_can_not_be_empty
            next
          end

          if script_name.include?(' ')
            Helpers::Messages.name_can_not_have_spaces
            next
          end

          if script_name.match?(/[^a-zA-Z0-9_-]/)
            Helpers::Messages.name_can_not_have_special_characters
            next
          end

          scripts_dir = Config.scripts_dir

          Dir.mkdir(scripts_dir) unless Dir.exist?(scripts_dir)

          # Check if file with this name exists

          if File.exist?("#{scripts_dir}/#{script_name}.sh")
            Helpers::Messages.script_exists
            next
          end

          Helpers::Messages.ask_for_description

          description = STDIN.gets.chomp

          File.open("#{scripts_dir}/#{script_name}.sh", 'w') do |file|
            file.puts('#!/bin/bash')
            file.puts("## dest: #{current_path}")
            file.puts("## description: #{description}")
            commands.each { |command| file.puts(command) }
          end

          Helpers::Messages.script_created(script_name)

          make_script_executable(script_name)

          break
        end
      end

      # ------------------------------------------------------------------------
      # Make the saved script executable
      def self.make_script_executable(script_name)
        system("chmod +x #{Config.scripts_dir}/#{script_name}.sh")
      end

      # ------------------------------------------------------------------------
      # Clean up the child process
      def self.clean(pid)
        Process.kill('TERM', pid)
      end
    end
  end
end
