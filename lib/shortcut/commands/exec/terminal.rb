module Shortcut
  module Commands
    module Exec
      class Terminal
        def self.call(_script_name, script_path)
          open_new_tab = Config.in_new_tab
          start_from = Config.env == :test ? '' : 'cd /Users &&'

          command =
            if open_new_tab
              <<~SCRIPT
                osascript -e 'tell application "Terminal"' \\
                  -e 'tell application "System Events" to keystroke "t" using command down' \\
                  -e 'do script "#{start_from} bash #{script_path.shellescape}" in front window' \\
                  -e 'end tell'
              SCRIPT
            else
              <<~SCRIPT
                osascript -e 'tell application "Terminal"' \\
                  -e 'do script "#{start_from} bash #{script_path.shellescape}" in front window' \\
                  -e 'end tell'
              SCRIPT
            end

          # Execute the script
          Kernel.system(command)

          # Move to the destination directory

          return if Config.env == :test

          script_info = Helpers::Deserialize.call(script_name)
          destination = script_info[:dest]

          return unless destination

          move_to_command = <<~SCRIPT
            osascript -e 'tell application "Terminal"' \\
              -e 'do script "cd #{destination}" in front window' \\
          SCRIPT

          Kernel.system(move_to_command)
        end
      end
    end
  end
end
