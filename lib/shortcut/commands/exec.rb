require 'shellwords'

require_relative 'exec/iterm'
require_relative 'exec/terminal'

module Shortcut
  module Commands
    module Exec
      # ------------------------------------------------------------------------
      def self.call(script_name)
        script_path = "#{Config.scripts_dir}/#{script_name}.sh"

        unless File.exist?(script_path)
          Helpers::Messages.script_not_found(script_name)
          return
        end

        case ENV['TERM_PROGRAM']
        when 'iTerm.app'
          ITerm.call(script_name, script_path)
        when 'Apple_Terminal'
          Terminal.call(script_name, script_path)
        else
          Helpers::Messages.terminal_not_supported
        end
      end
    end
  end
end
