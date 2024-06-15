# frozen_string_literal: true

require 'fileutils'

module Shortcut
  module Commands
    module Export
      def self.call
        print 'In which directory you would like to export?'

        path = STDIN.gets.chomp

        unless Dir.exist?(Config.scripts_dir)
          Helpers::Messages.no_scripts_found
          return
        end

        unless Dir.exist?(path)
          Helpers::Messages.directory_not_found
          return
        end

        copy_files(path)
      end

      def self.copy_files(destination_dir)
        Dir.glob("#{Config.scripts_dir}/*").each do |source_item|
          item_name = File.basename(source_item)
          destination_item = File.join(destination_dir, item_name)

          next unless !File.directory?(source_item) && File.extname(item_name) == '.sh'

          script_name = File.basename(source_item, File.extname(source_item))
          script_info = Helpers::Deserialize.call(script_name)

          unless File.exist?(destination_item)
            FileUtils.cp(source_item, destination_item) unless File.exist?(destination_item)
            Helpers::Messages.script_copied(destination_item, script_name, script_info[:description])
          end
        end
      end
    end
  end
end
