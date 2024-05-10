require 'fileutils'

module Shortcut
  module Helpers
    class Deserialize
      # ------------------------------------------------------------------------
      def self.call(script_name)
        script_path = "#{Config.scripts_dir}/#{script_name}.sh"

        unless File.exist?(script_path)
          Helpers::Messages.script_not_found(script_name)
          return { dest: '', description: '' }
        end

        dest = ''
        description = ''

        File.open(script_path, 'r') do |file|
          file.each_line do |line|
            dest = line.gsub('## dest: ', '').strip if line.match?(/## dest: /)

            description = line.gsub('## description: ', '').strip if line.match?(/## description:/)
          end
        end

        { dest:, description: }
      end
    end
  end
end
