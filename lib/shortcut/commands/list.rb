require 'pty'
require 'fileutils'

module Shortcut
  module Commands
    module List
      # ------------------------------------------------------------------------
      def self.call
        if Dir.exist?(Config.scripts_dir)
          script_files = Dir.glob("#{Config.scripts_dir}/*.sh")

          if script_files.empty?
            Helpers::Messages.no_scripts_found
          else

            max = script_files.map { |file| File.basename(file, '.sh').length }
                              .max

            max = 4 if max < 4

            puts 'Available scripts:'
            puts 'index' + ' | ' + 'name'.center(max) + ' | ' + 'description'

            script_files.sort.each_with_index do |file_path, index|
              file_name = File.basename(file_path, '.sh')
              script_info = Helpers::Deserialize.call(file_name)

              puts "#{index}".center(5) + ' | ' + File.basename(
                file_name,
                '.sh'
              ).center(max) + ' | ' + script_info[:description]
            end
          end
        else
          FileUtils.mkdir_p(Config.scripts_dir)
          Helpers::Messages.no_scripts_found
        end
      end
    end
  end
end
