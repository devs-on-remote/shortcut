require 'rainbow'

module Shortcut
  module Helpers
    class Messages
      # ------------------------------------------------------------------------
      def self.script_not_found(script_name)
        puts("Script '#{script_name}' not found.")
      end

      # ------------------------------------------------------------------------
      def self.terminal_not_supported
        puts('Terminal not supported! Please use iTerm or Apple Terminal.')
      end

      # ------------------------------------------------------------------------
      def self.script_exists
        puts(Rainbow('Script with this name already exists!').red)
      end

      # ------------------------------------------------------------------------
      def self.no_scripts_found
        puts('No scripts found.')
      end

      # ------------------------------------------------------------------------
      def self.script_deleted(script_name)
        puts("Script '#{script_name}' has been deleted.")
      end

      # ------------------------------------------------------------------------
      def self.name_can_not_be_empty
        puts(Rainbow("Script name can't be empty").red)
      end

      # ------------------------------------------------------------------------
      def self.name_can_not_have_spaces
        puts(Rainbow("Script name can't have spaces").red)
      end

      # ------------------------------------------------------------------------
      def self.name_can_not_have_special_characters
        puts(Rainbow('Script name must be alphanumeric. Signs allowed: _-').red)
      end

      # ------------------------------------------------------------------------
      def self.script_created(script_name)
        puts(Rainbow("Saved script as `#{script_name}` :)").green)
      end

      # ------------------------------------------------------------------------
      def self.ask_for_script_name
        print(Rainbow("\u279C ").yellow + 'Provide a name for the script: ')
      end

      # ------------------------------------------------------------------------
      def self.ask_for_description
        print(Rainbow("\u279C ").yellow + 'Provide a description to the command (will be visible when you list it): ')
      end

      # ------------------------------------------------------------------------
      def self.on_record_init
        puts(Rainbow('Recording a new script...').yellow)
        puts(Rainbow("'sc-stop' - stop recording").indianred)
        puts(Rainbow("'sc-undo' - undo the last command").indianred)
      end

      # ------------------------------------------------------------------------
      def self.all_commands
        puts(Rainbow('Usage:').yellow)
        puts(Rainbow('`sc <script_name>` to execute a script').indianred)
        puts(Rainbow('`sc <script_name> <script_name>` to execute multiple scripts').indianred)
        puts(Rainbow('`sc --list` to see all available scripts').indianred)
        puts(Rainbow('`sc --record` to record a new script').indianred)
        puts(Rainbow('`sc --delete <script_name>` to delete a script').indianred)
        puts(Rainbow('`sc --edit` to edit saved script').indianred)
        puts(Rainbow('`sc --version` to see the current version').indianred)
        puts(Rainbow('`sc --license` to see the license').indianred)
        puts(Rainbow('`sc --export` to export all scripts').indianred)
      end

      # ------------------------------------------------------------------------
      def self.script_edited(script_name, new_script_name, new_description)
        puts(Rainbow("Script '#{script_name}' has been edited to '#{new_script_name}' with description '#{new_description}'.").green)
      end

      # ------------------------------------------------------------------------
      def self.help_message
        all_commands
      end

      # ------------------------------------------------------------------------
      def self.script_copied(path_to_script, script_name, description)
        puts(Rainbow("Script '#{script_name}' has been copied to '#{path_to_script}' with description '#{description}'.").green)
      end

      # ------------------------------------------------------------------------
      def self.directory_not_found(dir)
        puts("Directory '#{dir}' not found.")
      end

      # ------------------------------------------------------------------------
      def self.version
        puts("Shortcut version: #{VERSION}")
      end

      # ------------------------------------------------------------------------
      def self.license
        license_path = File.expand_path('../../../LICENSE.txt', __dir__)

        if File.exist?(license_path)
          puts(File.read(license_path))
        else
          puts('License file not found.')
        end
      end
    end
  end
end
