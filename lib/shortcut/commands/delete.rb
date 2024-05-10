require 'fileutils'

module Shortcut
  module Commands
    module Delete
      # ------------------------------------------------------------------------
      def self.call
        print 'What script would you like to delete? '

        script_name = STDIN.gets.chomp

        unless Dir.exist?(Config.scripts_dir)
          Helpers::Messages.no_scripts_found
          return
        end

        script_path = File.join(Config.scripts_dir, "#{script_name}.sh")

        if File.exist?(script_path)
          FileUtils.rm(script_path)
          Helpers::Messages.script_deleted(script_name)
        else
          Helpers::Messages.script_not_found(script_name)
        end
      end
    end
  end
end
