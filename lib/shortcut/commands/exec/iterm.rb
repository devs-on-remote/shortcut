module Shortcut
  module Commands
    module Exec
      class ITerm
        def self.call(script_name, script_path)
          open_new_tab = Config.in_new_tab
          start_from = Config.env == :test ? '' : 'cd /Users &&'

          command =
            if open_new_tab
              <<~SCRIPT
                osascript -e 'tell application "iTerm"' \\
                  -e 'tell current window' \\
                  -e 'create tab with default profile' \\
                  -e 'tell current session' \\
                  -e 'write text "#{start_from} bash #{script_path.shellescape}"' \\
                  -e 'end tell' \\
                  -e 'end tell' \\
                  -e 'end tell'
              SCRIPT
            else
              <<~SCRIPT
                osascript -e 'tell application "iTerm"' \\
                  -e 'tell current window' \\
                  -e 'tell current session' \\
                  -e 'write text "#{start_from} bash #{script_path.shellescape}"' \\
                  -e 'end tell' \\
                  -e 'end tell' \\
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
            osascript -e 'tell application "iTerm"' \\
              -e 'tell current window' \\
              -e 'tell current session' \\
              -e 'write text "cd #{destination}"' \\
              -e 'end tell' \\
              -e 'end tell' \\
              -e 'end tell'
          SCRIPT

          Kernel.system(move_to_command)
        end
      end
    end
  end
end
