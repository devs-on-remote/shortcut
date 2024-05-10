require 'fileutils'

module Shortcut
  module Commands
    module Edit
      # ------------------------------------------------------------------------
      def self.call
        print 'Which script would you like to edit? '

        script_name = STDIN.gets.chomp

        unless Dir.exist?(Config.scripts_dir)
          Helpers::Messages.no_scripts_found
          return
        end

        script_path = File.join(Config.scripts_dir, "#{script_name}.sh")

        if File.exist?(script_path)
          print 'How should it be called? '

          new_script_name = STDIN.gets.chomp

          print 'What should the new description be? '

          new_description = STDIN.gets.chomp

          new_script_path = File.join(Config.scripts_dir, "#{new_script_name}.sh")

          FileUtils.mv(script_path, new_script_path)

          File.open(new_script_path, 'r') do |file|
            lines = file.readlines
            lines[0] = "#!/bin/bash\n"
            lines[1] = "## dest: #{Config.scripts_dir}\n"
            lines[2] = "## description: #{new_description}\n"
            File.open(new_script_path, 'w') do |file|
              file.puts(lines)
            end
          end

          print 'Would you like to edit the script in vim? [Yes (yY)/ No (anything else)] '

          edit_in_vim = STDIN.gets.chomp

          loop do
            break unless %w[y Y].include?(edit_in_vim)

            system("vim #{new_script_path}")
            break
          end

          Helpers::Messages.script_edited(script_name, new_script_name, new_description)
        else
          Helpers::Messages.script_not_found(script_name)
        end
      end
    end
  end
end
